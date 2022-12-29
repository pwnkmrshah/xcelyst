module BxBlockProfile
  class ProfilesController < ApplicationController
    # before_action :check_candidate_role, except: [:filters, :show, :recommended_roles]

    # Create by Punit
    # Update Profile or if not exist it will Create of Candidate 
    def create
      if !current_user.profile
        profile_params = jsonapi_deserialize(params)
        @profile = BxBlockProfile::Profile.create(profile_params.merge({ account_id: current_user.id }))
        if @profile.save
          BxBlockProfile::ProfileMailer.with(email: current_user.email).edit_profile_you.deliver_now
          render json: BxBlockProfile::ProfileSerializer.new(@profile).serializable_hash, status: :created
        else
          render json: {
                   errors: format_activerecord_errors(@profile.errors),
                 }, status: :unprocessable_entity
        end
      else
        profile_params = jsonapi_deserialize(params)
        @profile = current_user.profile
        if @profile.update(profile_params)
          BxBlockProfile::ProfileMailer.with(email: current_user.email).edit_profile_you.deliver_now
          render json: ProfileSerializer.new(@profile).serializable_hash, status: :ok
        else
          render json: {
                   errors: format_activerecord_errors(@profile.errors),
                 }, status: :unprocessable_entity
        end
      end
    end

    # Create by Punit
    # Show Profile or other information of cnadidate if user is clinet show account informations
    def show
      profile = current_user.profile
      if current_user.user_role == "client"
        render json: ClientProfileSerializer.new(current_user).serializable_hash, status: 200
      elsif current_user.user_role == "candidate"
        if profile.present?
          render json: ProfileSerializer.new(profile).serializable_hash, status: :ok
        else
          render json: { errors: "profile not found" }, status: :ok
        end
      end
    end

    # Create by Punit
    # Show RecommendedRoles for a user usign the user's Resume and also this and filter the Roles
    def recommended_roles
      return render json: { errors: "Wrong params." }, status: :unprocessable_entity unless (params[:roles_type] == "similiar_job" || current_user.present? )
      roles = RecommendedRoles.new(current_user, params).call
      if current_user.present? || params[:roles_type] != "similiar_job"
        applied_jobs = current_user.profile.applied_jobs
        profile_id = current_user.profile.id
        save_jobs = BxBlockSaveJob::SaveJob.where(profile_id: profile_id, favourite: true)
      end
      options = { params: { applied_jobs: applied_jobs, save_jobs: save_jobs,  user_role: current_user.present? ? current_user.user_role : "guest_user" }}
      if roles.success?
        render json: { roles: BxBlockRolesPermissions::RolesSerializer.new(roles.data, options).serializable_hash, total: roles.total }, status: :ok
      else
        render json: { errors: "data not found" }, status: :unprocessable_entity
      end
    end
    
    # Create by Punit
    # Get they Filters Data of the Roles and User can filter roles useing this filter data
    def filters
      roles = BxBlockRolesPermissions::Role.all
      filters = Filters.new(roles).call
      if filters.success?
        render json: { filters: filters.data }, status: :ok
      else
        render json: { errors: "data not found" }, status: :unprocessable_entity
      end
    end

    # Create by Punit
    # Get the User Applied Job Data 
    def appied_job_list
      jobes =  current_user.profile.applied_jobs.where(status: ["accepted", "pending"]).select {|job| !(job.role.is_closed) }
      if jobes
        render json: BxBlockProfile::AppliedJobListSerializer.new(jobes).serializable_hash, status: :ok
      else
        render json: { message: "jobes not found" }, status: 200
      end
    end

    # Create by Punit
    # Get the User Applied Job Data they Roles are Closed Now
    def past_appied_job_list
      jobes =  current_user.profile.applied_jobs.select {|job| job.role.is_closed || job.status == 'rejected' }
      if jobes.length > 0
        render json: BxBlockProfile::AppliedJobListSerializer.new(jobes).serializable_hash, status: :ok
      else
        render json: { message: "jobes not found" }, status: 200
      end
    end

    def update
      status, result = UpdateAccountCommand.execute(@token.id, update_params)
      if status == :ok
        serializer = AccountBlock::AccountSerializer.new(result)
        render :json => serializer.serializable_hash,
          :status => :ok
      else
        render :json => { :errors => [{ :profile => result.first }] },
          :status => status
      end
    end

    def destroy
      profile = BxBlockProfile::Profile.find(params[:id])
      if profile.present?
        profile.destroy
        render json: { meta: { message: "Profile Removed" } }
      else
        render json: { meta: { message: "Record not found." } }
      end
    end

    def update_profile
      profile = BxBlockProfile::Profile.find_by(id: params[:id])
      profile.update(profile_params)
      if profile&.photo&.attached?
        render json: ProfileSerializer.new(profile, meta: {
                                                      message: "Profile Updated Successfully",
                                                    }).serializable_hash, status: :ok
      else
        render json: {
          errors: format_activerecord_errors(profile.errors),
        }, status: :unprocessable_entity
      end
    end

    def user_profiles
      profiles = current_user.profiles
      render json: ProfileSerializer.new(profiles, meta: {
                                                     message: "Successfully Loaded",
                                                   }).serializable_hash, status: :ok
    end

    private

    # def profile_params
    #   params.require(:profile).permit(:id, :country, :address, :city, :postal_code, :photo, :profile_role)
    # end

    def update_params
      params.require(:data).permit \
        :first_name,
        :last_name,
        :current_password,
        :new_password,
        :new_email,
        :new_phone_number
    end
  end
end
