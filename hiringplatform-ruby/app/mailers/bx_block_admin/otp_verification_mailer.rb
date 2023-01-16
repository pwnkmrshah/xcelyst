module BxBlockAdmin
  class OtpVerificationMailer < ApplicationMailer

    def request_otp
      @admin = params[:admin]
      mail(to: @admin.email, from: 'builder.bx_dev@engineer.ai', subject: 'OTP Verification.')
    end  

  end
end
  