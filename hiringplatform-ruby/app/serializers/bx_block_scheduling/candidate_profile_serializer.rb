module BxBlockScheduling
 	class CandidateProfileSerializer < BuilderBase::BaseSerializer
 		
    attribute :full_name do |obj|
      "#{obj.first_name} #{obj.last_name}"
    end

    attributes :photo do |obj|
      if obj.avatar.attached?
        host = Rails.application.routes.default_url_options[:host]
        host+Rails.application.routes.url_helpers.rails_blob_url(obj.avatar, only_path: true)
      end
    end

    attribute :email do |obj|
      obj.email
    end

    attribute :phone_number do |obj|
      obj.phone_number
    end

    attribute :work_experience do |obj|
      resume = obj.user_resume
      if resume.present?
        begin
          resume = resume.get_parsed_resume_data
          resume['Value']['ResumeData']['ResumeMetadata']['PlainText']
        rescue => exception
          " "
        end
      else
        " "
      end
    end

    attribute :applied_id do |obj, params|
      obj.applied_jobs.where(role_id: params[:role].id).first&.id 
    end

    attribute :resume do |obj|
      host = Rails.application.routes.default_url_options[:host]
      
      if obj.resume_image.attached?
        host+Rails.application.routes.url_helpers.rails_blob_url(obj.resume_image, only_path: true)
      end
    end

    attribute :skills do |obj|
      user_skills = obj.user_preferred_skills
      if user_skills.present?
        skills_id = user_skills.pluck(:preferred_skill_id)
        BxBlockPreferredRole::PreferredSkill.where(id: skills_id)
      else
        "No skills found."
      end
    end

    attributes :role_id do |obj,params|
      role = params[:role]
      role.id 
    end

    attributes :role_name do |obj,params|
      role = params[:role]
      role.name
    end

    attributes :job_description do |obj,params|
      role = params[:role]
      role.job_description 
    end

    attributes :scheduled_data do |obj,params|
      interviews = check_scheduled_interview(obj,params)
      interviews.map do |interview|
        if interview.present?
          {
            is_already_scheduled: true,
            interviewer: interview&.interviewer&.name,
            time_slots: interview
          }
        else
          {
            is_already_scheduled: false,
            time_slots: nil,
            interviewer: nil
          }
        end
      end.compact
    end
    
    class << self
      private

      def check_scheduled_interview obj, params
        role = params[:role]
        client_id = role.account_id
        jd_id = role.job_description.id
        BxBlockScheduling::ScheduleInterview.where(account_id: obj.id, role_id: role.id, client_id: client_id)
      end

    end

  end
end