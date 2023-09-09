module BxBlockAdmin
  class OtpVerificationMailer < ApplicationMailer

    def request_otp(email)
      fetch_email(email)
    end
  end
end
  