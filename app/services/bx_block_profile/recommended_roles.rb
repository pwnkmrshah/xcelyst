module BxBlockProfile
  class RecommendedRoles
    def initialize(current_user, params)
      @current_user = current_user
      @params = params
    end

    def call
      case @params[:roles_type]
      when "others"
        others_jobs
      when "cv_based"
        cv_based_jobs
      when "similiar_job"
        similiar_jobs
      end
    end

    def others_jobs
      roles = BxBlockRolesPermissions::Role.where(is_closed: false)
      if @params[:filters].present? && @params[:filters].first[:type].present? && @params[:filters].first[:values].present?
        roles = BxBlockProfile::Filters.get_filter_role(@params[:filters], roles)
        roles = BxBlockRolesPermissions::Role.where(id: roles, is_closed: false)
      end
      response = roles.order("created_at DESC").page(@params[:page] || 1).per(@params[:per_page] || 10)
      return OpenStruct.new(success?: true, data: response, total: roles.count)
    end

    def similiar_jobs
      role = BxBlockRolesPermissions::Role.find(@params[:role_id])
      if role&.job_description&.jd_type == "manual"
        skills = role.job_description.domain_sub_categories.pluck(:name)
        skills = skills + role.job_description.others_skills
      else
        skills = get_skills(role.job_description)
      end
      roles = BxBlockRolesPermissions::Role.joins(job_description: [:domain_sub_categories]).where(is_closed: false, domain_sub_categories: { name: skills }).ids
      roles = BxBlockRolesPermissions::Role.where(id: roles)
			response = Kaminari.paginate_array(roles).page(@params[:page] || 1).per(@params[:per_page] || 10)
      return OpenStruct.new(success?: true, data: response, total: roles.count)
    end

    def cv_based_jobs
      skills = []
      user_skills_ids = @current_user.user_preferred_skills.ids.uniq
      preferred_skills = BxBlockPreferredRole::PreferredSkill.joins(:user_preferred_skills).where(user_preferred_skills: {id: user_skills_ids}).pluck(:name)
      preferred_skills = preferred_skills + @current_user.profile.preferred_role_ids
      preferred_skills.present? &&  preferred_skills.uniq.map do |p|
          s = BxBlockDomainSubCategory::DomainSubCategory.ransack(name_cont: p).result.ids
          skills = skills + s
      end
      role_ids = BxBlockJobDescription::JobDescription.joins(:domain_sub_categories).where(domain_sub_categories: {id: skills}).pluck(:role_id)
      if @params[:filters].present? && @params[:filters].first[:type].present? && @params[:filters].first[:values].present?
        role_ids = BxBlockProfile::Filters.get_filter_role(@params[:filters], role_ids)
      end
      roles = BxBlockRolesPermissions::Role.where(id: role_ids, is_closed: false)
      response = roles.order("created_at DESC").page(@params[:page] || 1).per(@params[:per_page] || 10)
      return OpenStruct.new(success?: true, data: response, total: roles.count)
    end

    def get_skills(jd)
      skills = []
      jd&.parsed_jd["JobData"]["SkillsData"] && jd.parsed_jd["JobData"]["SkillsData"].each do |skill_data|
        skill_data["Taxonomies"].present? && skill_data["Taxonomies"].map do |taxonomie|
          taxonomie["SubTaxonomies"].present? && taxonomie["SubTaxonomies"].each do |sub_taxonomy|
            sub_taxonomy["Skills"].present? && sub_taxonomy["Skills"].map do |skill|
              skills << skill["Name"]
            end
          end
        end
      end
      skills
    end
  end
end
