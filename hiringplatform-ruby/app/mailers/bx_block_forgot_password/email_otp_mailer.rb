module BxBlockForgotPassword
  class EmailOtpMailer < ApplicationMailer
    def otp_email
      fetch_email(@record.email)
    end
  end
end
