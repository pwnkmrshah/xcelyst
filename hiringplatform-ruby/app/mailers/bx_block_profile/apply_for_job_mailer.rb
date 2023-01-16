module BxBlockProfile
  class ApplyForJobMailer < ApplicationMailer
    def job_applied
      @job = params[:job]
      @host = params[:host]
      @email = "info@xcelyst.com"
      mail(
        to: @email,
        from: "builder.bx_dev@engineer.ai",
        subject: "Apply for a job",
      ) do |format|
        format.html { render "job_applied" }
      end
    end

    def apply_for_job
      @email = params[:email]
      mail(to: @email, subject: "You applied for job", body: "You applied for job successfully")
    end
    
  end
end
