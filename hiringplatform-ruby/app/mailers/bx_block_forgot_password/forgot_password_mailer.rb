 module BxBlockForgotPassword
    class ForgotPasswordMailer < ApplicationMailer
       def forgot_password_you
        @email = params[:email]
        mail(to: @email, from: 'builder.bx_dev@engineer.ai', subject: 'Password has been updated successfully', body: "Password has been updated successfully")
    	end       
   end
end
  