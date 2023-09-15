module BxBlockRolesPermissions
  class ApplyJobMailer < ApplicationMailer
      def apply_job_you
        @email = params[:email]
        mail(to: @email, from: 'info@xcelyst.com', subject: 'Job Apply Succesfuly.', body: "Job Apply Succesfuly.")
      end
   end
end
   
