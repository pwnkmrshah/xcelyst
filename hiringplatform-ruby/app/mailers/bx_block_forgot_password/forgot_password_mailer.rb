 module BxBlockForgotPassword
    class ForgotPasswordMailer < ApplicationMailer
       def forgot_password_you
         fetch_email('forgot_password_you', @record.email)
    	end       
   end
end
