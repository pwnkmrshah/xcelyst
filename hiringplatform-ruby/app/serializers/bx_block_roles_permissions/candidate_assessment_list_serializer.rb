module BxBlockRolesPermissions
  class CandidateAssessmentListSerializer < BuilderBase::BaseSerializer
    attributes *[
                 :id,
                 :candidate_name,
                 :role,
                 :applied_id,
                 :feedback,
                 :initial_score,
               ]

    attribute :id do |object|
      object.profile.id
    end

    attribute :applied_id do |object|
      object.id
    end

    attribute :candidate_name do |object|
      object.profile.account.first_name + " " + object.profile.account.last_name
    end

    attribute :role do |object|
      object.role.name
    end

    attribute :feedback do |object|
      object.final_feedback
    end

    attribute :initial_score do |object|
      begin
        object&.shortlisting_candidate&.sovren_score
      rescue => exception
        0
      end
    end
  end
end
