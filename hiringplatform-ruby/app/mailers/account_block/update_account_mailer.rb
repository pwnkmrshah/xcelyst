module AccountBlock
    class UpdateAccountMailer < ApplicationMailer
      def update_pic
        @email = params[:email]
        mail(to: @email, from: 'builder.bx_dev@engineer.ai', subject: 'Account Profile Pic Changed Successfully', body: "Your Profile Pic Updated Successfully.")
      end  

      def update_profile
        @email = params[:email]
        mail(to: @email, from: 'builder.bx_dev@engineer.ai', subject: 'Account Updated Successfully', body: "Your Updated Successfully.")
      end
   end
end
  