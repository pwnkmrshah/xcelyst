module BxBlockRolesPermissions
  class ApplyCandidateListSerializer < BuilderBase::BaseSerializer
    attributes *[
                 :role_name,
                 :candidate,
                 :accepted_candidate,
                 :is_closed,
                 :position,
               ]

    attribute :role_name do |object|
      object.name
    end

    attribute :accepted_candidate do |object|
      object.applied_jobs.where(status: "accepted").count
    end

    attribute :candidate do |object, params|
      canidates = []
      applied_jobs = object.applied_jobs
      if params[:search].present?
        candidate_ids = AccountBlock::Account.ransack(first_name_or_last_name_cont: params[:search]).result.ids
        profile_ids = BxBlockProfile::Profile.where(account_id: candidate_ids).ids
        applied_jobs = applied_jobs.where(profile_id: profile_ids)
      end
      if params[:candidate_order].present?
        applied_jobs = applied_jobs.joins(:account).order(params[:candidate_order])
      end
      applied_jobs = applied_jobs.page(params[:page] || 1).per(params[:per_page] || 3)

      applied_jobs.map do |applied_job|
        shortlised = applied_job&.shortlisting_candidate
        profile = applied_job&.profile
        account = profile&.account
        host = Rails.application.routes.default_url_options[:host]
        if shortlised.present? && shortlised.shortlisted_by_admin == "true"
          canidates << {
            profile_id: profile.id,
            account_id: account.id,
            phone_number: account.phone_number,
            email: account.email,
            name: account.first_name + " " + account.last_name,
            photo: account.avatar.attached? ? host + Rails.application.routes.url_helpers.rails_blob_url(account.avatar, only_path: true) : "",
            resume: account.resume_image.attached? ? host + Rails.application.routes.url_helpers.rails_blob_url(account.resume_image, only_path: true) : "",
            initial_score: shortlised&.sovren_score,
            final_score: applied_job.final_score,
            assessment_stage: applied_job.assessment_staged,
            feedback: applied_job.final_feedback,
            final_feedback: applied_job.final_feedback,
            date_opened: applied_job.role.created_at,
            status: applied_job.status || "pending",
          }
        end
      end.compact
      if object.is_closed
        canidates.map do |candidate|
          candidate["date_closed"] = object.updated_at
          candidate["flag"] = "Lorem ipsum"
        end
      end
      canidates
    end

    attribute :total_applied_candidate do |object, params|
      object.applied_jobs.count
    end

    attribute :total_shortlisted_candidate do |object, params|
      shortlisted_candidates(object, "true")
    end

    attribute :rejected_candidate do |object|
      object.applied_jobs.where(status: "rejected").count
    end

    class << self
      private

      def initial_score(account)
        begin
          account.user_resume.sovren_score
        rescue => exception
          0
        end
      end

      def shortlisted_candidates(object, is_shortlisted)
        if object.job_description
          BxBlockShortlisting::ShortlistingCandidate.where(job_description_id: object.job_description.id, shortlisted_by_admin: is_shortlisted).count
        else
          0
        end
      end
    end
  end
end
