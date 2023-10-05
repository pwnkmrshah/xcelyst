module BxBlockAdmin
  class OtpVerificationMailer < ApplicationMailer
    include EmailHelper
    before_action :set_values

    def request_otp(email)
      fetch_email(email)
    end
  end
end
  