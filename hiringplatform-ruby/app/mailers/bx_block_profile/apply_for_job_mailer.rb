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
      fetch_email('apply_for_job')
    end
  end
end
