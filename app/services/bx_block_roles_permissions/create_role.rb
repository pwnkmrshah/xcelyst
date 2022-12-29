# Create by Punit
module BxBlockRolesPermissions
  class CreateRole
    def initialize(roles_params, job_desc_params, skills_params, current_user)
      @roles_params = roles_params
      @job_desc_params = job_desc_params
      @skills_params = skills_params
      @current_user = current_user
    end

    # Createing a role, job description and skills matrice these are associated to each.
    def call
      begin
        ActiveRecord::Base.transaction(isolation: :serializable) do
          if !@roles_params["is_closed"] && @roles_params["position"].to_i > 0
            role = BxBlockRolesPermissions::Role.create!(@roles_params.merge(account_id: @current_user.id))
            skills_id = @skills_params.pluck(:skill_id, :preferred_skill_level_ids)
            job = BxBlockJobDescription::JobDescription.create!(@job_desc_params.merge(role_id: role.id, is_manual_jd: true, skills: skills_id ))
            # Making a skills Martice attribute hash for create skillMatrice 
            skills_params = @skills_params.map do |i|
              {
                job_description_id: job.id,
                domain_sub_category_id: i[:skill_id],
                preferred_overall_experience_ids: i[:preferred_overall_experience_ids],
                preferred_skill_level_ids: i[:preferred_skill_level_ids],
              }
            end
            skill_matrice = BxBlockSkillMatrice::SkillMatrice.create!(skills_params)
            return OpenStruct.new(success?: true, obj: role)
          else
            return OpenStruct.new(success?: false, errors: "wrong parameters.")
          end
        end
      rescue Exception => e
        return OpenStruct.new(success?: false, errors: e)
      end
    end
  end
end
