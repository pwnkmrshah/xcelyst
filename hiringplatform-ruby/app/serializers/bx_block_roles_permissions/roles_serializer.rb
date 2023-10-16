require 'json'

module BxBlockRolesPermissions
  class RolesSerializer < BuilderBase::BaseSerializer
    attributes *[
                 :name,
                 :company_name,
                 :tags,
                 :position,
                 :managers,
                 :is_closed,
                 :jd_automatic,
                 :applied,
                 :saved,
                 :created_at,
                 :updated_at,
                 :job_description,
               ]

    attribute :job_description do |object|
      job = object.job_description
      if job.present?
        {
          job_description_id: job.id,
          job_title: job.job_title,
          jd_file: job.jd_file.service_url,
          degree: job.degree,
          fieldOfStudy: job.fieldOfStudy,
          role_title: job.role_title,
          preferred_overall_experience: preferred_overall_experience(job),
          minimum_salary: job.minimum_salary,
          location: job.location,
          company_description: job.company_description,
          job_responsibility: job.job_responsibility,
          others_skill: job.others_skills,
          currency: job.currency,
          skills: skills(job),
        }
      end
    end

    attribute :company_name do |object|
      "#{object.account.first_name} #{object.account.last_name}"
    end

    attribute :company_email do |object|
      object.account.email
    end

    attribute :user_role do |obj, params|
      params[:user_role]
    end

    attribute :tags do |object|
      ["Full time", "Min 1 Year", "Director"]
    end

    attribute :applied do |object, params|
      if params.present?
        applied = params[:applied_jobs].where(role_id: object.id) rescue nil
        applied.present?
      end
    end

    attribute :saved do |object, params|
      if params.present?
        saved = params[:save_jobs].where(role_id: object.id, favourite: true) rescue nil
        saved.present?
      end
    end

    attribute :jd_automatic do |object|
      object.job_description.present? && object.job_description.has_attribute?("jd_type") && object.job_description.jd_type == "automatic"
    end

    attribute :managers do |obj|
      begin
        obj&.managers&.map{ |j| JSON.parse j.gsub('=>', ':') }
      rescue => exception
        []
      end
    end

    class << self
      private

      def skills(job)
        if job.jd_type.present? && job.jd_type == "automatic"
          if job.parsed_jd.is_a? Hash
            job.parsed_jd
          elsif job.parsed_jd.is_a? String
            file = job.parsed_jd
            jd = job.parse_jd_data(file)
            jd['Value']
          end          
        else
          job.skill_matrices && job.skill_matrices.map do |skill|
            {
              id: skill_id(skill),
              skill_name: skill_name(skill),
              overall_expericen: overall_experience(skill),
              skill_level: skill_level(skill),
            }
          end
        end
      end

      def skill_id(skill)
        s = BxBlockDomainSubCategory::DomainSubCategory.find(skill.domain_sub_category_id)
        s.id
      end

      def skill_name(skill)
        s = BxBlockDomainSubCategory::DomainSubCategory.find(skill.domain_sub_category_id)
        s.name
      end

      def overall_experience(skill)
        experience = BxBlockPreferredOverallExperiences::PreferredOverallExperiences.where(id: skill.preferred_overall_experience_ids)
        experience.map do |ex|
          {
            id: ex.id,
            experiences_year: ex.experiences_year,
            level: ex.level,
            grade: ex.grade,
          }
        end
      end

      def skill_level(skill)
        experience = BxBlockPreferredOverallExperiences::PreferredSkillLevel.where(id: skill.preferred_skill_level_ids)
        experience.map do |ex|
          {
            id: ex.id,
            experiences_year: ex.experiences_year,
            level: ex.level,
          }
        end
      end

      def preferred_overall_experience(job)
        experience = BxBlockPreferredOverallExperiences::PreferredOverallExperiences.find(job.preferred_overall_experience_id)
        {
          id: experience.id,
          experiences_year: experience.experiences_year,
          level: experience.level,
          grade: experience.grade,
        }
      end
    end
  end
end
