require 'uri'
module AccountBlock
  class AccountsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    # for validate json tokenw
    before_action :validate_json_web_token, only: [:search, :verify_otp, :resend_otp]
    before_action :find_account, only: [:verify_otp, :resend_otp]

    # Create a new account with Email or Phone Number informations this is Sigup API Code
    def remove_resume
      @candidate = AccountBlock::Account.find_by(id: params[:user_id])
      @candidate.resume_image.purge if @candidate.resume_image.present?
      resume = @candidate.user_resume
      if resume.present?
        resume.parse_resume.purge if resume.parse_resume.present?
        resume.destroy
        @candidate.user_preferred_skills.destroy_all if @candidate.user_preferred_skills.present?
      end
      return render json: { success: true, message: 'Resume has been deleted successfully.'}
    end

    def create
      case params[:data][:type] #### rescue invalid API format
      when "sms_account"
        validate_json_web_token

        unless valid_token?
          return render json: { errors: [
                          { token: "Invalid Token" },
                        ] }, status: :bad_request
        end

        begin
          @sms_otp = SmsOtp.find(@token[:id])
        rescue ActiveRecord::RecordNotFound => e
          return render json: { errors: [
                          { phone: "Confirmed Phone Number was not found" },
                        ] }, status: :unprocessable_entity
        end

        params[:data][:attributes][:full_phone_number] =
          @sms_otp.full_phone_number
        @account = SmsAccount.new(jsonapi_deserialize(params))
        @account.activated = true
        if @account.save
          render json: SmsAccountSerializer.new(@account, meta: {
                                                     token: encode(@account.id),
                                                   }).serializable_hash, status: :created
        else
          render json: { errors: format_activerecord_errors(@account.errors) },
            status: :unprocessable_entity
        end
      when "email_account"
        if params[:data][:user_type] == "candidate"
          account_params = jsonapi_deserialize(params)

          query_email = account_params["email"].downcase
          account = EmailAccount.where("LOWER(email) = ?", query_email).first
          phone_no_account = Account.where(phone_number: account_params["phone_number"])

          return render json: {error: {message: "Email & Phone no has been already taken"}},
                        status: :unprocessable_entity if account && phone_no_account.first.present?
          
          return render json: {error: {message: "Phone no has been already taken"}},
                        status: :unprocessable_entity if phone_no_account.first.present?


          return render json: { error: { message: "already_existed" }, meta: {token: encode(account.id)} },
                        status: :unprocessable_entity if account && !account.activated

          return render json: { errors: [
                          { account: "Email has already been taken." },
                        ] }, status: :unprocessable_entity if account

          validator = EmailValidation.new(account_params["email"])

          return render json: { errors: [
                          { account: "Incorrect Email and Password." },
                        ] }, status: :unprocessable_entity if !validator.valid?

          begin
            ActiveRecord::Base.transaction(isolation: :serializable) do

              @account = EmailAccount.new(jsonapi_deserialize(params))
              @account.resume_image = params[:resume]
              if @account.save
                profile = BxBlockProfile::Profile.new(account_id: @account.id)
                if profile.save
                  BxBlockSovren::Sovren.new(params[:resume], @account).execute
                  return render json: EmailAccountSerializer.new(@account, meta: {
                                                                      token: encode(@account.id),
                                                                    }).serializable_hash, status: :created
                else
                  return render json: { error: profile.errors }, status: :unprocessable_entity
                end
              else
                return render json: { errors: format_activerecord_errors(@account.errors) },
                  status: :unprocessable_entity
              end
            end
          rescue Exception => e
            return render json: { errors: e }, status: :unprocessable_entity
          end
        else
          render json: { errors: "Not a valid user type" }, status: :unprocessable_entity
        end
      when "social_account"
        @account = SocialAccount.new(jsonapi_deserialize(params))
        @account.password = @account.email
        if @account.save
          render json: SocialAccountSerializer.new(@account, meta: {
                                                        token: encode(@account.id),
                                                      }).serializable_hash, status: :created
        else
          render json: { errors: format_activerecord_errors(@account.errors) },
            status: :unprocessable_entity
        end
      else
        render json: { errors: [
          { account: "Invalid Account Type" },
        ] }, status: :unprocessable_entity
      end
    end

    def search
      @accounts = Account.where(activated: true)
        .where("first_name ILIKE :search OR " \
               "last_name ILIKE :search OR " \
               "email ILIKE :search", search: "%#{search_params[:query]}%")
      if @accounts.present?
        render json: AccountSerializer.new(@accounts, meta: { message: "List of users." }).serializable_hash, status: :ok
      else
        render json: { errors: [{ message: "Not found any user." }] }, status: :ok
      end
    end

    # created by punit
    # client set password, set password page send data.
    def update
      if params.has_key?(:account_id)
        @account = Account.find(params[:account_id].to_i)
        if params.has_key?(:password) && params.has_key?(:password_confirmation) && params[:password] == params[:password_confirmation]
          if @account.reset_password_token.present?
            @account.update(password: params[:password], password_confirmation: params[:password_confirmation], reset_password_token: nil, activated: true)
            AccountBlock::SetPasswordMailer.with(account_id: @account.id).client_changed_password.deliver_now
            redirect_to "#{ENV["FRONT_END_URL"]}login/?type=client"
          else
            @error = "token_error"
          end
        else
          @error = "password_error"
        end
      end
    end

    # Create by Punit
    # Updte Account (user) Informations like phone number email, address
    def update_account
      if current_user.user_role == "candidate"
        account_params = jsonapi_deserialize(params)
        begin
          current_user.update!(account_params)
          UpdateAccountMailer.with(email: current_user.email).update_profile.deliver_now
          components = [
            {"type": "header", "parameters": [{ "type": "text", "text": "#{current_user.user_full_name}" }],
            },
            {"type": "body", "parameters": [{"type": "text", "text": "Profile" }]
            }]
            response = BxBlockTwilio::ChatTwilio.send_whatspp_message(current_user, "candidate_profile_update", components)
          render json: { data: current_user.as_json(only: [:first_name, :last_name, :current_city, :phone_number, :email]) }, status: 200
        rescue => e 
          if e.message == "Validation failed: Phone number has already been taken"
            render json: {errors: "Phone number has already been taken"}, stataus: :unprocessable_entity
          else
            render json: {errors: e}, stataus: :unprocessable_entity
          end
        end
      else
        render json: { errors: "Not a valid user type" }, status: :unprocessable_entity
      end
    end

    # created by punit
    # go to the client set password page
    def set_password
      if params[:token]
        @account = Account.find_by(reset_password_token: params[:token].to_s)
        if !@account.present?
          @error = "token_error"
        end
      else
        render json: { errors: "This is Not valid link" }, status: :unprocessable_entity
      end
    end

    # created by akash deep
    # to resend the otp
    def resend_otp
      @account.generate_pin_and_valid_date
      @account.save
      host = ENV['REMOTE_URL']
      email = EmailValidationMailer
        .with(account_id: @account.id, host: request.base_url)
        .activation_email.deliver
      render json: { message: "OTP has been sent successfully." }, status: 200
    end

    # created by akash deep
    # to verify the otp
    def verify_otp
      if (params[:otp].present? && params[:otp].to_i == @account.otp && (@account.otp_valid_till > Time.zone.now))
        @account.update activated: true, otp: nil, otp_valid_till: nil
        AccountBlock::SignUpMailer.with(email: @account.email).sign_up_you.deliver_now
        # AccountBlock::SignUpMailer.with(account: @account).sovren_score.deliver_now
        components = [{
            type: 'HEADER', parameters: [ { type: 'text', text: @account.user_full_name }]
          }]
        BxBlockTwilio::ChatTwilio.send_whatspp_message(@account, "onboarding_template", components)
        render json: { message: "Account has been verified successfully." }, status: 200
      else
        render json: { errors: "Something went wrong." }, status: :unprocessable_entity
      end
    end

    # Create by Punit
    # Update Profile Pic of Candidate and Client
    def photo_update
      if current_user && params[:photo]
        current_user.avatar.purge if current_user.avatar.attached?
        if current_user.avatar.attach(params[:photo])
          host = Rails.application.routes.default_url_options[:host]
          image = host+Rails.application.routes.url_helpers.rails_blob_url(current_user.avatar, only_path: true)
          UpdateAccountMailer.with(email: current_user.email).update_pic.deliver_now
          render json: { photo: image }, status: :ok
        else
          render json: { errors: current_user.errors }, status: :unprocessable_entity
        end
      else
        render json: { errors: "Something went wrong." }, status: :unprocessable_entity
      end
    end

    # created by punit
    # Remove the profile pic 
    def remove_photo
      if current_user
        current_user.avatar.purge if current_user.avatar.attached?
        render json: {message: "Profile Photo remove successfully"}, status: :ok
      else
        render json: {errors: "User not found"}, status: :unprocessable_entity
      end
    end

    # Create by Punit 
    # Reset the password only for Client
    def reset_password
      @account = Account.find(params[:id])
      tokan = DateTime.now.strftime("%Q").to_s
      host = ENV['REMOTE_URL']
      if @account.update(reset_password_token: tokan)
        AccountBlock::SetPasswordMailer.with(account_id: params[:id], host: host).reset_password.deliver
        redirect_to "#{host}/admin/clients/#{@account.id}", flash: { notice: "Password reset Email sended successfully!" }
      end
    end

    private

    # Create by Punit
    # method for get Current User by Token
    def current_user
      validate_json_web_token
      @current_user = AccountBlock::Account.find(@token.id)
      unless @current_user.present?
        render json: { error: "Account not present." }, status: :unprocessable_entity
      end
      @current_user
    end

    def encode(id)
      BuilderJsonWebToken::JsonWebToken.encode id, 'app_user'
    end

    def find_account
      @account = Account.find @token.id
      unless @account.present?
        render json: { error: "Account not present." }, status: :unprocessable_entity
      end
    end

    def search_params
      params.permit(:query)
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end
  end
end
