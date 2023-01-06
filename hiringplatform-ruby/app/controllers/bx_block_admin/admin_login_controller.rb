module BxBlockAdmin 
  class AdminLoginController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :admin_user, only: [:otp_verify, :logout, :refresh_token]

    # created by akash deep
    # validate the admin email and password and send him a otp.
    def create
      admin = AdminUser.find_by(email: params[:email])
      if admin && admin.valid_password?(params[:password])
        generate_pin_and_valid_date admin
        BxBlockAdmin::OtpVerificationMailer.with(admin: admin).request_otp.deliver_now
        render json: AdminUserSerializer.new(admin, meta: { token: encode(admin.id, 'admin_otp') } ).serializable_hash, status: :ok
      else
        render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
      end
    end
    
    # created by akash deep
    # verify the otp, if it's correct admin will successfully login.
    def otp_verify
      if (params[:otp].present? && params[:otp] == @admin.otp && (@admin.otp_valid_till > Time.zone.now))
        @admin.update logged_in: true, otp: nil, otp_valid_till: nil
        render json: AdminUserSerializer.new(@admin, meta: { token: encode(@admin.id, 'admin') } ).serializable_hash, status: 200
      else
        render json: { message: "Invalid OTP or OTP may expired." }, status: :unprocessable_entity
      end
    end

    # created by akash deep
    # logout api to make logged_in as false.    
    def logout
      if @admin.update logged_in: false
        render json: { message: 'Logout successfully.' }, status: 200
      else
        render json: { errors: 'Something went wrong.' }, status: :unprocessable_entity
      end
    end

    # created by akash deep
    # refresh token api to stay on admin console more than usual time.
    def refresh_token
      if @token.admin_id.present? && @admin.logged_in
        render json: AdminUserSerializer.new(@admin, meta: { refresh_token: encode(@admin.id, 'admin') } ).serializable_hash, status: 200
      else
        render json: { errors: [token: 'Invalid token or Admin may not be logged in.'] }, status: :bad_request
      end
    end

    private

    def encode(id, user_type)
      BuilderJsonWebToken.encode id, user_type
    end

    def admin_user
      validate_json_web_token
      if @token.admin_id.present?
        @admin = AdminUser.find(@token.admin_id)
      elsif @token.auth_admin_id.present?
        @admin = AdminUser.find(@token.auth_admin_id)
      else
        return render json: { errors: [token: 'Invalid token'] }, status: :bad_request
      end
    end

    def generate_pin_and_valid_date admin
      admin.otp = rand(1_00000..9_99999)
      admin.otp_valid_till = Time.zone.now + 5.minutes
      admin.save
    end
    
  end
end