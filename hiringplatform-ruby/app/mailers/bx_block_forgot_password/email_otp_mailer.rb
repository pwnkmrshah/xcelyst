module BxBlockForgotPassword
  class EmailOtpMailer < ApplicationMailer
    def otp_email
      @account = params[:account]
      @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]
      mail(
          to: @account.email,
          subject: "Password Reset Request: One-Time Password Inside") do |format|
        format.html { render 'otp_email' }
      end
    end
  end
end
