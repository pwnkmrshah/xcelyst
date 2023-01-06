module BxBlockProfile
    class ProfileMailer < ApplicationMailer
			
      def edit_profile_you
        @email = params[:email]
        mail(to: @email, from: 'builder.bx_dev@engineer.ai', subject: 'Edit Profile Picture', body: "Edited Your Profile.")
      end       
   end
end
  