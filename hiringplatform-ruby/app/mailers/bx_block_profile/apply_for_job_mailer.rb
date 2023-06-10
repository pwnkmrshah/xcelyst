module BxBlockProfile
  class ApplyForJobMailer < ApplicationMailer
    def job_applied
      @job = params[:job]
      @host = params[:host]
      @email = "info@xcelyst.com"
      mail(
        to: @email,
        subject: "Apply for a job",
      ) do |format|
        format.html { render "job_applied" }
      end
    end

    def apply_for_job
      @email = params[:email]
      @user = AccountBlock::Account.find_by(email: @email)&.user_full_name
      mail(to: @email, subject: "Job Application Submitted Successfully")
    end
    
  end
end
