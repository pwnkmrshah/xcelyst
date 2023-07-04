 module BxBlockForgotPassword
    class ForgotPasswordMailer < ApplicationMailer
       def forgot_password_you
         fetch_email(@record.email)
    	end       
   end
end
