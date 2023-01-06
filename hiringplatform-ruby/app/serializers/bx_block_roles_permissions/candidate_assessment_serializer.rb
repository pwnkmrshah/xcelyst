module BxBlockRolesPermissions
  class CandidateAssessmentSerializer < BuilderBase::BaseSerializer
    attributes *[
                 :id,
                 :candidate_name,
                 :profile_id,
                 :role,
                 :role_id,
                 :initial_score,
                 :final_score,
                 :final_feedback,
                 :assessment_test_scores,
                 :hr_assessment,
                 :video_interview,
                 :hiring_manger_assessment,
                 :feedback,
                 :status,
                 :accepted,
                 :photo,
               ]

    attribute :profile_id do |object|
      object.profile.id
    end

    attribute :role_id do |object|
      object.role.id
    end

    attribute :is_closed do |object|
      object.role.is_closed
    end

    attribute :candidate_name do |object|
      object.profile.account.first_name + " " + object.profile.account.last_name
    end

    attribute :role do |object|
      object.role.name
    end

    attribute :initial_score do |object|
      begin
        object&.shortlisting_candidate&.sovren_score
      rescue => exception
        0
      end
    end

    attribute :feedback do |object|
      begin
        object.interview_feedbacks.present?
      rescue => exception
        false
      end
    end

    attribute :final_score do |object|
      object.final_score
    end

    attribute :final_feedback do |object|
      object.final_feedback
    end

    attribute :assessment_test_scores do |object|
      test(object)
    end

    attribute :hr_assessment do |object|
      if object.role.job_description.present?
        interview = BxBlockScheduling::ScheduleInterview.where(job_description_id: object.role.job_description.id, account_id: object.profile.account.id, interview_type: "hr_assessment")
        interviewer_data(interview)
      end
    end

    attribute :hiring_manger_assessment do |object|
      if object.role.job_description.present?
        interview = BxBlockScheduling::ScheduleInterview.where(job_description_id: object.role.job_description.id, account_id: object.profile.account.id, interview_type: "hiring_manger_assessment")
        interviewer_data(interview)
      end
    end

    attribute :video_interview do |object|
      if object.role.job_description.present?
        interview = BxBlockScheduling::ScheduleInterview.where(job_description_id: object.role.job_description.id, account_id: object.profile.account.id, interview_type: "video_interview")
        interviewer_data(interview)
      end
    end

    attributes :photo do |obj|
      if obj.profile.account.avatar.attached?
        host = Rails.application.routes.default_url_options[:host]
        host+Rails.application.routes.url_helpers.rails_blob_url(obj.profile.account.avatar, only_path: true)
      end
    end
    class << self
      private

      def test(object)
        test_score = []
        test_score_and_courses = object.account.test_score_and_courses
        test_score_and_courses.present? && test_score_and_courses.map do |test|
          if test.role_ids && test.role_ids.include?(object.role.id)
            test_score << {
              name: test.title,
              score: test.score,
              associated_with: test.associated_with,
              test_date: test.test_date,
              description: test.description,
              status: test.status,
              invitation_end_date: test.invitation_end_date,
              make_public: test.make_public,
              test_id: test.test_id,
              test_url: test.test_url,
            }
          end
        end.compact
        test_score
      end

      def interviewer_data interviews
        interviews.present? && interviews.map do |interview|
          {
            "id": interview&.id,
            "account_id": interview&.account_id,
            "job_description_id": interview&.job_description_id,
            "role_id": interview&.role_id,
            "first_slot": interview&.first_slot,
            "second_slot": interview&.second_slot,
            "third_slot": interview&.third_slot,
            "require_admin_support": interview&.require_admin_support,
            "preferred_slot": interview&.preferred_slot,
            "is_accepted_by_candidate": interview&.is_accepted_by_candidate,
            "request_alt_slots": interview&.request_alt_slots,
            "created_at": interview&.created_at,
            "updated_at": interview&.updated_at,
            "client_id": interview&.client_id,
            "interview_type": interview&.interview_type,
            "feedback": interview&.feedback,
            "interviewer_id": interview&.interviewer_id,
            "rating": interview&.rating,
            "time_zone": interview&.time_zone,
            "interviewer_name": interview&.interviewer&.name
          }
        end
      end
    end
  end
end
