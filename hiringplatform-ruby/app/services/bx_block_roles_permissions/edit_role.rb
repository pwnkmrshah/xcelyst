# Create by Punit 
module BxBlockRolesPermissions
  class EditRole
    def initialize(roles_params, job_desc_params, skills_params, current_user)
      @roles_params = roles_params
      @job_desc_params = job_desc_params
      @skills_params = skills_params
      @current_user = current_user
    end

    # Updateing role job descrption and Deleteign skills matics after that we createing new.
    def call
      begin
        role = BxBlockRolesPermissions::Role.find(@roles_params["id"])
        return OpenStruct.new(success?: false, errors: "wrong parameters.") unless role.account_id == @current_user.id
        ActiveRecord::Base.transaction(isolation: :serializable) do
          role.update!(@roles_params)
          job = role.job_description
          skills_id = @skills_params.pluck(:skill_id, :preferred_skill_level_ids)
          job.update!(@job_desc_params.merge(is_manual_jd: true, skills: skills_id ))
          skill_matrice = job.skill_matrices.delete_all
          # Making a skills Martice attribute hash for create skillMatrice 
          skills_params = @skills_params.map do |i|
            {
              job_description_id: job.id,
              domain_sub_category_id: i["skill_id"],
              preferred_overall_experience_ids: i["preferred_overall_experience_ids"],
              preferred_skill_level_ids: i["preferred_skill_level_ids"],
            }
          end
          skill_matrice = BxBlockSkillMatrice::SkillMatrice.create!(skills_params)
          return OpenStruct.new(success?: true, obj: role)
        end
      rescue Exception => e
        return OpenStruct.new(success?: false, errors: e)
      end
    end
  end
end
