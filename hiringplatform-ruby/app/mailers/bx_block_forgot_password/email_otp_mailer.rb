module BxBlockForgotPassword
  class EmailOtpMailer < ApplicationMailer
    def otp_email
      @account = params[:account]
      @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]
      mail(
          to: @account.email,
          from: 'builder.bx_dev@engineer.ai',
          subject: 'Your OTP code') do |format|
        format.html { render 'otp_email' }
      end
    end
  end
end
