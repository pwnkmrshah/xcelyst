module BxBlockRolesPermissions
  class RolesController < ApplicationController
    before_action :check_client_role, except: [:show]
    before_action :create_title_suggetion, only: [:create]

    # create by punit
    # create Role
    def create
      roles_params = jsonapi_deserialize(params)
      job_desc_params = jsonapi_deserialize(params["data"]["job_description"])
      skills_params = params["data"]["job_description"]["data"]["skills"]
      role = CreateRole.new(roles_params, job_desc_params, skills_params, current_user).call
      if role.success?
        BxBlockRolesPermissions::JobDescriptionMailer.with(info_email: "info@xcelyst.com", obj: role.obj.job_description, type: "created").automate_jd_to_admin.deliver_now
        BxBlockRolesPermissions::JobDescriptionMailer.with(email: role.obj.account.email, obj: role.obj.job_description, type: "created").automate_jd_to_client.deliver_now
        render json: BxBlockRolesPermissions::RolesSerializer.new(role.obj).serializable_hash, status: :created
      else
        render json: { errors: role.errors }, status: :unprocessable_entity
      end
    end

    # create by punit 
    # Edit or Update Role
    def update
      roles_params = jsonapi_deserialize(params)
      job_desc_params = jsonapi_deserialize(params["data"]["job_description"])
      skills_params = params["data"]["job_description"]["data"]["skills"]
      role = EditRole.new(roles_params, job_desc_params, skills_params, current_user).call
      if role.success?
        BxBlockRolesPermissions::JobDescriptionMailer.with(info_email: "info@xcelyst.com", obj: role.obj.job_description, type: "updated").automate_jd_to_admin.deliver_now
        BxBlockRolesPermissions::JobDescriptionMailer.with(email: role.obj.account.email, obj: role.obj.job_description, type: "updated").automate_jd_to_client.deliver_now
        render json: BxBlockRolesPermissions::RolesSerializer.new(role.obj).serializable_hash, status: :created
      else
        render json: { errors: role.errors }, status: :unprocessable_entity
      end
    end

    def close_role
      role = Role.find(params[:role_id])
      ActiveRecord::Base.transaction(isolation: :serializable) do
        begin
          role.update(is_closed: params[:is_closed])
          role.applied_jobs.where(status: ["pending"]).update_all(status: "rejected", accepted: false)
          render json: { message: "Role has been updated" }, status: :ok
        rescue StandardError => e
          render json: { errors: e }, status: :unprocessable_entity
        end
      end
    end

    # create by punit 
    # Delete the Roles by id
    def destroy
      begin
        role = current_user.roles.find(params[:id])
        role.destroy
        return render json: {message: "roles delete successfully"}, status: :ok
      rescue => exception
        return render json: {error: role.errors}, status: :unprocessable_entity
      end
    end

    # create by punit
    # Send client all Roles on Client dashborad
    def get_roles
      @roles = current_user.roles
      if @roles && @roles.length > 0
        open_roles = @roles.where(is_closed: false).order("created_at DESC")
        closed_roles = @roles.where(is_closed: true).order("created_at DESC")
        candidate_scoring = BxBlockRolesPermissions::AppliedJob.where(role_id: open_roles.ids, status: ["accepted", "pending"]).count
        render json: { open_roles: DashboardSerializer.new(open_roles).serializable_hash,
                       closed_roles: DashboardSerializer.new(closed_roles).serializable_hash,
                       total_open_roles: open_roles.count,
                       total_close_roles: closed_roles.count,
                       candidate_scoring: candidate_scoring }, status: :ok
      else
        render json: { error: "Not found roles" }, status: :unprocessable_entity
      end
    end

    # created by punit
    # send candidate list they apply for roles
    def apply_candidate_list
        if params[:search] && !params[:role_id].present?
          options = { params: { is_closed: params[:is_closed], page: params[:candidate_page], per_page: params[:candidate_per_page], candidate_order: params[:candidate_order] } }
          roles_ids = current_user.roles.ransack(name_cont: params[:search]).result.ids
          roles = current_user.roles.where(id: roles_ids, is_closed: params[:is_closed])
          roles_count = roles.count
          roles = roles.order(params[:role_order] || "created_at DESC").page(params[:role_page] || 1).per(params[:role_per_page] || 10)
          return render json: { total_roles: roles_count, applied_candidates: BxBlockRolesPermissions::ApplyCandidateListSerializer.new(roles, options).serializable_hash() }, status: :ok
        end
        if !params[:role_id].present?
          options = { params: { is_closed: params[:is_closed], page: params[:candidate_page], per_page: params[:candidate_per_page], candidate_order: params[:candidate_order]} }
          roles_count = current_user.roles.where(is_closed: params[:is_closed]).count
          roles = current_user.roles.where(is_closed: params[:is_closed]).order(params[:role_order] || "created_at DESC").page(params[:role_page] || 1).per(params[:role_per_page] || 10)
          return render json: { total_roles: roles_count, applied_candidates: BxBlockRolesPermissions::ApplyCandidateListSerializer.new(roles, options).serializable_hash() }, status: :ok
        elsif params[:role_id].present?
          role = Role.find(params[:role_id])
          options = { params: { page: params[:candidate_page], per_page: params[:candidate_per_page], candidate_order: params[:candidate_order], search: params[:search]  } }
          return render json: { applied_candidates: BxBlockRolesPermissions::ApplyCandidateListSerializer.new(role, options).serializable_hash() }, status: :ok
        end
    end

    # created by punit
    # Get Role with Job_description details
    def show
      if current_user&.user_role == "candidate"
        applied_jobs = current_user.profile.applied_jobs rescue nil
        profile_id = current_user.profile.id
        save_jobs = BxBlockSaveJob::SaveJob.where(profile_id: profile_id, favourite: true)
      end
      options = { params: { applied_jobs: applied_jobs, save_jobs: save_jobs, user_role: current_user.present? ? current_user.user_role : "guest_user" } }
      role = BxBlockRolesPermissions::Role.find(params["id"])
      render json: BxBlockRolesPermissions::RolesSerializer.new(role, options).serializable_hash, status: :ok
    end

    # created by punit
    # Open & Closed roles list search
    def search_role
      roles = current_user.roles.where("lower(name) LIKE ?", "%#{params[:role_name].downcase}%")
      options = { params: { page: params[:page], per_page: params[:per_page] } }
      if roles.present?
        render json: BxBlockRolesPermissions::ApplyCandidateListSerializer.new(roles, options).serializable_hash(), status: :ok
      else
        render json: { errors: { message: "Data not found" } }, status: :unprocessable_entity
      end
    end

    # create by punit 
    # Search Candidate by First Name
    def search_candiate
      roles_id = current_user.roles.map(&:id)
      account_ids = AccountBlock::Account.where("lower(first_name) LIKE ?", "%#{params[:name].downcase}%").where(user_role: "candidate").map(&:id)
      profile_ids = BxBlockProfile::Profile.where(account_id: account_ids).ids
      shortlisting_ids = BxBlockShortlisting::ShortlistingCandidate.where(is_shortlisted: true).ids
      roles = BxBlockRolesPermissions::Role.joins(:applied_jobs).where(:applied_jobs => { :profile_id => profile_ids, :shortlisting_candidate_id => shortlisting_ids, status: ["pedding", "pending", "accepted"] })
      options = { params: { page: params[:page], per_page: params[:per_page] } }
      if roles.length > 0
        render json: BxBlockRolesPermissions::ApplyCandidateListSerializer.new(roles, options).serializable_hash(), status: :ok
      else
        render json: { errors: "data not found" }, status: :unprocessable_entity
      end
    end

    # created by punit
    # Send allcandidate list they appliced client role for job
    def candidate_accessment_list
      if params[:name]
        account_ids = AccountBlock::Account.ransack(first_name_or_last_name_cont: params[:name]).result.where(user_role: "candidate").ids
        profile_ids = BxBlockProfile::Profile.where(account_id: account_ids).ids
        roles = current_user.roles.where(is_closed: false)
        roles_id = roles.where("lower(name) LIKE ?", "%#{params[:name].downcase}%").ids
        applied_jobs = BxBlockRolesPermissions::AppliedJob.where(profile_id: profile_ids, role_id: roles.ids, status: ["accepted", "pending"])
        applied_jobs = applied_jobs.or(BxBlockRolesPermissions::AppliedJob.where(role_id: roles_id, status: ["accepted", "pending"]))
      else
        roles_id = current_user.roles.where(is_closed: false).ids
        applied_jobs = BxBlockRolesPermissions::AppliedJob.where(role_id: roles_id, status: ["accepted", "pending"])
      end
      hash = CandidateAssessmentListSerializer.new(applied_jobs).serializable_hash
      case params[:sort]
      when "score"
        sort = hash[:data].sort_by { |hsh| hsh[:attributes][:initial_score].to_i }
      when "name"
        sort = hash[:data].sort_by { |hsh| hsh[:attributes][:candidate_name].to_s }
      when "role_name"
        sort = hash[:data].sort_by { |hsh| hsh[:attributes][:role].to_s }
      else
        sort = hash[:data]
      end
      candidates = Kaminari.paginate_array(sort).page(params[:page] || 1).per(params[:per_page] || 10)
      render json: { candidate: { data: candidates }, total_candidaate: applied_jobs.count }, status: :ok
    end

    # created by punit
    # Send candidate details for assessment
    def candidate_accessment
      applied_jobs = BxBlockRolesPermissions::AppliedJob.find(params[:applied_id])
      render json: CandidateAssessmentSerializer.new(applied_jobs).serializable_hash, status: :ok
    end
    
    # create by punit 
    # create suggectiones for Job TItle and Role Title
    def create_title_suggetion
      jd_name = []
      jd_name << params["data"]["job_description"]["data"]["attributes"]["job_title"]
      jd_name << params["data"]["job_description"]["data"]["attributes"]["job_title"]
      jd_name << params["data"]["job_description"]["data"]["attributes"]["role_title"]
      jd_name << params["data"]["attributes"]["name"]
      jd_name.present? && jd_name.map do |a|
        job_suggestion = BxBlockSuggestion::JobSuggestion.where(suggestion: a) if a.present?
        unless job_suggestion.present?
          BxBlockSuggestion::JobSuggestion.create(suggestion: a)
        end
      end
    end
  end
end
