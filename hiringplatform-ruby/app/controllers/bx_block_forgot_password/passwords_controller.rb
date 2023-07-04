module BxBlockForgotPassword
  class PasswordsController < ApplicationController

    before_action :check_user_through_email
    before_action :check_otp, only: :create

    def request_otp
      if @account.user_role == 'candidate'
        otp = rand(1_00000..9_99999)
        # otp = 6.times.map{rand(10)}.join
        if @account.update(otp: otp, otp_valid_till: (Time.zone.now + 5.minutes))
          EmailOtpMailer.with(email: @account.email).otp_email.deliver
          render json: {message: "OTP has been sent to your given email address." }, status: 200  
        else
          render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: {errors: "Not for client"}, status: :unprocessable_entity
      end
    end
    
    def create
      if create_params[:password] == create_params[:password_confirmation] 
        if !(@account.otp_valid_till < Time.zone.now)
          if @account.update(password: create_params[:password], password_confirmation: create_params[:password_confirmation],
            otp: nil, otp_valid_till: nil)
          BxBlockForgotPassword::ForgotPasswordMailer.with(email: @account.email).forgot_password_you.deliver_now
            render json: { message: "Password has been updated successfully." }, status: 200
          else
            render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: {errors: "OTP has expired"}, status: :unprocessable_entity
        end
      else
        render json: { errors: "Password mismatch." }, status: :unprocessable_entity
      end
    end

    def request_otp_client
      if @account.user_role == 'client'
        otp = rand(1_00000..9_99999)
        if @account.update(otp: otp, otp_valid_till: (Time.zone.now + 5.minutes))
          BxBlockForgotPassword::EmailOtpMailer.with(account: @account, host: request.base_url).otp_email.deliver
          render json: {message: "OTP has been sent to your given email address." }, status: 200  
        else
          render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: {errors: "Not for candidate"}, status: :unprocessable_entity
      end
    end

    def create_params
      params.require(:data)
        .permit(*[
          :email,
          :otp,
          :password,
          :password_confirmation
        ])
    end

    def check_user_through_email
    
      
      @account = AccountBlock::Account.where('LOWER(email) = ?', create_params[:email].downcase).first
      unless @account.present?
        return render json: { errors: "Email doesn't exist." }, status: :unprocessable_entity
      end
    end

    def check_otp
      unless @account.otp == create_params[:otp].to_i
        return render json: { errors: "Incorrect OTP." }, status: :unprocessable_entity
      end
    end
  end
end

