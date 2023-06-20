module BxBlockRolesPermissions
  class JobDescriptionMailer < ApplicationMailer
    def job_description_you
      @email = params[:email]
      mail(to: @email, subject: 'Job Description Created successfully.', body: "Job Description Created successfully.")
    end

    def automate_jd_to_admin
      fetch_email('automate_jd_to_admin')
    end

    def automate_jd_to_client
      fetch_email('automate_jd_to_client')
    end
  end
end