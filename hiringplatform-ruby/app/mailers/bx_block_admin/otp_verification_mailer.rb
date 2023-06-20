module BxBlockAdmin
  class OtpVerificationMailer < ApplicationMailer

    def request_otp
      fetch_email('request_otp')
    end
  end
end
  