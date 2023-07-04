module BxBlockAdmin
  class OtpVerificationMailer < ApplicationMailer

    def request_otp
      fetch_email(@record.email)
    end
  end
end
  