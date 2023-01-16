class BxBlockSaveJob::SaveJobsController < ApplicationController
  include BuilderJsonWebToken::JsonWebTokenValidation

  # create by punit
  # create save job for candidate can make favourite job list
  def create
    profile_id = current_user.profile.id
    save_job = BxBlockSaveJob::SaveJob.find_by(role_id: params["data"]["role_id"], profile_id: profile_id)
    if !save_job
      save_job = BxBlockSaveJob::SaveJob.create(role_id: params["data"]["role_id"], profile_id: profile_id, favourite: params["data"]["favourite"])
      if save_job.save
        render json: { data: save_job.as_json(only: [:id, :role_id, :profile_id, :favourite]) }, status: :ok
      else
        render json: { errors: save_job.errors }, status: :unprocessable_entity
      end
    else
      save_job.update(favourite: params["data"]["favourite"])
      render json: { data: save_job.as_json(only: [:id, :role_id, :profile_id, :favourite]) }, status: :ok
    end
  end

  def show
    begin
      applied_jobs = current_user.profile.applied_jobs rescue nil
      profile_id = current_user.profile.id
      save_jobs = BxBlockSaveJob::SaveJob.where(profile_id: profile_id, favourite: true)
      options = { params: { applied_jobs: applied_jobs, save_jobs: save_jobs } }
      roles = save_jobs.map(&:role)
      if roles.present?
        render json: BxBlockRolesPermissions::RolesSerializer.new(roles, options), status: :ok
      else
        render json: { message: "data not found" }, status: 200
      end
    rescue => exception
      render json: { errors: "data not found" }, status: :unprocessable_entity
    end
  end
end
