module BxBlockRolesPermissions
  class JobDescriptionMailer < ApplicationMailer
    def job_description_you
      @email = params[:email]
      mail(to: @email, from: 'builder.bx_dev@engineer.ai', subject: 'Job Description Created successfully.', body: "Job Description Created successfully.")
    end

    def automate_jd_to_admin
      host = ENV['REMOTE_URL'] || Rails.application.routes.default_url_options[:host]
      @email = params[:email]
      @jd = params[:obj]
      @type = params[:type]
      @jd_url = host+Rails.application.routes.url_helpers.rails_blob_url(@jd.jd_file, only_path: true)
      mail(to: @email,
        subject: "New Job Description Created: #{@jd&.role&.account&.first_name} - #{@type} - #{@jd.jd_type}") do |format|
        format.html { render 'automate_jd_to_admin' }
      end
    end

    def automate_jd_to_client
      host = ENV['REMOTE_URL'] || Rails.application.routes.default_url_options[:host]
      @email = params[:email]
      @jd = params[:obj]
      @type = params[:type]
      @jd_url = host+Rails.application.routes.url_helpers.rails_blob_url(@jd.jd_file, only_path: true)
      mail(to: @email,
        subject: "Job Description Created: #{@type} - #{@jd.jd_type}") do |format|
        format.html { render 'automate_jd_to_client' }
      end
    end

  end
end