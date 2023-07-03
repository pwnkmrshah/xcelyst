module BxBlockForgotPassword
  class EmailOtpMailer < ApplicationMailer
    def otp_email
      fetch_email('otp_email', @record.emai)
    end
  end
end
