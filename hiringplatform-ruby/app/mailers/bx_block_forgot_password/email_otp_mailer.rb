module BxBlockForgotPassword
  class EmailOtpMailer < ApplicationMailer
    def otp_email(account=nil)
      fetch_email(account.email)
    end
  end
end
