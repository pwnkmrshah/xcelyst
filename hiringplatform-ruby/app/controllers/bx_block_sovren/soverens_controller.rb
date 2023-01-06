module BxBlockSovren
  class SoverensController < ApplicationController
    before_action :current_user, only: [:job_description, :update_resume, :remove_resume, :update_job_description]
    before_action :check_user_role, only: [:job_description, :update_job_description]
    before_action :find_client_jd, only: :update_job_description
    before_action :check_jd_file_exist?, only: :update_job_description

    require 'uri'
    require 'net/http'
    require 'net/https'
    require 'base64'
    require 'json'
    

    def create
      file_path = params['resume']
      file_data = IO.binread(file_path)
      modified_date = File.mtime(file_path).to_s[0,10]
       
      # Encode the bytes to base64
      base_64_file = Base64.encode64(file_data)
      data = {
        "DocumentAsBase64String" => base_64_file,
        "DocumentLastModified" => modified_date
        #other options here (see https://sovren.com/technical-specs/latest/rest-api/resume-parser/api/)
      }.to_json
       
      #use https://eu-rest.resumeparsing.com/v10/parser/resume if your account is in the EU data center or
      #use https://au-rest.resumeparsing.com/v10/parser/resume if your account is in the AU data center
       
      uri = URI.parse("https://eu-rest.resumeparsing.com/v10/parser/resume")
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true
       
      headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Sovren-AccountId' => ENV['SOVREN_ID'] || '14044560', # use your account id here
        'Sovren-ServiceKey' => ENV['SOVREN_KEY'] || 'qQ8I+UkWFIRC0p9fx0GDq5wDCAw75mgNJERyB+RO', # use your service key here
      }
       
      req = Net::HTTP::Post.new(uri.path, initheader = headers)
      req.body = data
      res = https.request(req)
       
      # Parse the response body into an object
      respObj = JSON.parse(res.body)
      # Access properties such as the GivenName and PlainText
      render json: {key: respObj}
      # givenName = respObj["Value"]["ResumeData"]["ContactInformation"]["CandidateName"]["GivenName"]
      # resumeText = respObj["Value"]["ResumeData"]["ResumeMetadata"]["PlainText"]
    end

    # create by akash deep 
    # to update the resume and save the data into user resume table.
    # by using the sovren we will get the json data and later this data will write into a file
    # that file we will upload on to the s3 bucket.
    def update_resume
      x = BxBlockSovren::Sovren.new(params[:resume], current_user).execute
      if x.success?
        current_user.resume_image.attach(params[:resume])
        # user_parsed_resume = AccountBlock::UserParsedResume.find_by(user_resume_id: current_user.user_resume.id)
        user_resume = current_user.user_resume
        if user_resume.present? && ( user_resume.parsed_resume.present? || ( user_resume.parse_resume.present? && user_resume.parse_resume.attached? ))
          AccountBlock::SignUpMailer.with(account: current_user).sovren_score.deliver_now
           notification = BxBlockNotifications::Notification.create(
              headings: "Uploaded CV successfully",
              contents: "",
              account_id: current_user.id,
              notificable_id: user_resume.id,
              notificable_type: "AccountBlock::UserResume",
              is_read: false,
              notification_type: "uploaded_cv"
          )
          return render json: { message: 'Resume has been updated successfully.' }, status: 200
        else
          return render json: { message: "Resume doesn't have skills." }, status: 422
        end
      else
        render json: { errors: "Something went wrong."}, status: 422
      end
    end

    # created by akash deep
    # remove the user resume record and purge the resume image data from s3
    def remove_resume
      if current_user.user_role == 'candidate'
        current_user.resume_image.purge if current_user.resume_image.present?
        resume = current_user.user_resume
        if resume.present?
          # user_parsed_resume = AccountBlock::UserParsedResume.find_by(user_resume_id: resume.id)
          # user_parsed_resume.destroy if user_parsed_resume.present?
          resume.parse_resume.purge if resume.parse_resume.present?
          resume.destroy
          
          current_user.user_preferred_skills.destroy_all if current_user.user_preferred_skills.present?
          render json: { message: 'Resume has been deleted successfully.' }, status: 200
        else
          render json: { message: 'No Resume found.' }, status: 422
        end
      else
        render json: { message: 'Not a authorized role.' }, status: 422
      end
    end

    def job_description
      identifier = params[:identifier]
      jd = BxBlockSovren::Sovren.jd_parser(jd_params, @current_user, nil, identifier)
      if jd.success?
        render_success_for_jd jd.obj, 201, "created"
      else
        render json: { errors: jd.errors }, status: :unprocessable_entity
      end
    end

    def update_job_description
      identifier = @client_jd.present? ? @client_jd.document_id: params[:identifier]
      jd = BxBlockSovren::Sovren.jd_parser(jd_params, @current_user, @client_jd, identifier)
      if jd.success?
        render_success_for_jd jd.obj, 200, "updated"
      else
        return render json: { errors: jd.errors }, status: :unprocessable_entity
      end
    end

    private 

    def find_client_jd
      @client_jd = BxBlockJobDescription::JobDescription.find_by(id: params[:jd_id])
      unless @client_jd.present?
        return render json: { errors: "Invalid Job Description id." }, status: :unprocessable_entity
      end
    end

    def check_jd_file_exist?
      unless jd_params[:jd_file].present?
        jd_role = @client_jd.role
        if jd_role.update(jd_params)
          return render json: { data: @client_jd }, status: 200
        else
          return render json: { errors: jd_role.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end

    def render_success_for_jd jd, status_code, operation
      BxBlockRolesPermissions::JobDescriptionMailer.with(email: "info@xcelyst.com", obj: jd, type: operation).automate_jd_to_admin.deliver_now
      BxBlockRolesPermissions::JobDescriptionMailer.with(email: jd.role.account.email, obj: jd, type: operation).automate_jd_to_client.deliver_now
      return render json: { data: jd }, status: status_code
    end

    def jd_params
      params.permit(:position, :name, :jd_file, managers: [])
    end

    
  # end
  end
end
