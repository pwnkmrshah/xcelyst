module BxBlockRolesPermissions
  class ApplyCandidateSerializer < BuilderBase::BaseSerializer
    attributes *[
                 :profile_id,
                 :name,
                 :photo,
                 :resume,
                 :initial_score,
                 :final_score,
                 :assessment_stage,
                 :feedback,
                 :date_opened,
                 :status,
               ]

    attribute :profile_id do |object|
      object.profile.id
    end

    attribute :name do |object|
      object.profile.account.first_name + " " + object.profile.account.last_name
    end

    attribute :photo do |obj|
      if obj.profile.account.avatar.attached?
        host = Rails.application.routes.default_url_options[:host]
        host+Rails.application.routes.url_helpers.rails_blob_url(obj.profile.account.avatar, only_path: true)
      end
    end

    attribute :resume do |object|
      object.profile.account.photo
    end

    attribute :initial_score do |object|
      begin
        object&.shortlisting_candidate&.sovren_score
      rescue => exception
        0
      end
    end

    attribute :final_score do |object|
      object.final_score
    end

    attribute :assessment_stage do |object|
      object.assessment_staged
    end

    attribute :feedback do |object|
      object.final_feedback
    end

    attribute :date_opened do |object|
      object.role.created_at
    end

    attribute :status do |object|
      object.status || "pending"
    end
  end
end
