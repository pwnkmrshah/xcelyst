module BxBlockProfile
  class AppliedJobListSerializer < BuilderBase::BaseSerializer
    attributes *[
      :id,
      :role,
      :company,
      :test,
      :hr_assessment,
      :hiring_manger_assessment,
      :video_interview,
      :feedback,
      :status,
      :appliction_closed_on,
      :rejected_on,
    ]

    attributes :role do |object|
      object.role.name
    end

    attributes :company do |object|
      "#{object.role.account.first_name} #{object.role.account.last_name}"
    end

    attributes :test do |object|
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

    attribute :feedback do |object|
      object.final_feedback
    end

    attribute :hr_assessment do |object|
      if object.role.job_description.present?
        interviews = BxBlockScheduling::ScheduleInterview.where(job_description_id: object.role.job_description.id, account_id: object.profile.account.id, interview_type: "hr_assessment")
        interview = interviews.first
        if interviews.present?
          {
            account_id: interview.account_id,
            client_id: interview.client_id,
            interview_type: "hr_assessment",
            job_description_id: interview.job_description_id,
            role_id: interview.role_id,
            interviews: getinterviews(interviews),
            start_url: interview.zoom_meeting.present? ? interview.zoom_meeting.meeting_urls['start_url'] : nil,
            join_url: interview.zoom_meeting.present? ? interview.zoom_meeting.meeting_urls['join_url'] : nil
          }
        end
      end
    end

    attribute :hiring_manger_assessment do |object|
      if object.role.job_description.present?
        interviews = BxBlockScheduling::ScheduleInterview.where(job_description_id: object.role.job_description.id, account_id: object.profile.account.id, interview_type: "hiring_manger_assessment")
        interview = interviews.first
        if interviews.present?
          {
            account_id: interview.account_id,
            client_id: interview.client_id,
            interview_type: "hiring_manger_assessment",
            job_description_id: interview.job_description_id,
            role_id: interview.role_id,
            interviews: getinterviews(interviews),
            start_url: interview.zoom_meeting.present? ? interview.zoom_meeting.meeting_urls['start_url'] : nil,
            join_url: interview.zoom_meeting.present? ? interview.zoom_meeting.meeting_urls['join_url'] : nil
          }
        end
      end
    end

    attribute :video_interview do |object|
      if object.role.job_description.present?
        interviews = BxBlockScheduling::ScheduleInterview.where(job_description_id: object.role.job_description.id, account_id: object.profile.account.id, interview_type: "video_interview")
        interview = interviews.first
        if interviews.present?
          {
            account_id: interview.account_id,
            client_id: interview.client_id,
            interview_type: "video_interview",
            job_description_id: interview.job_description_id,
            role_id: interview.role_id,
            interviews: getinterviews(interviews),
            start_url: interview.zoom_meeting.present? ? interview.zoom_meeting.meeting_urls['start_url'] : nil,
            join_url: interview.zoom_meeting.present? ? interview.zoom_meeting.meeting_urls['join_url'] : nil           
          }
        end
      end
    end

    attribute :appliction_closed_on do |object|
        object.role.updated_at if object.role.is_closed
    end

    attribute :rejected_on do |object|
      if object.role&.is_closed
        "Role closed on- #{object.role.updated_at}"
      elsif object.status == "rejected"
        object.role.updated_at
      elsif object.status == "accepted"
        "NA"
      end
    end

    class << self
      private

      def getinterviews(interviews)
        if interviews
          interviews.map do |interview|
            {
              id: interview.id,
              created_at: interview.created_at,
              first_slot: interview.first_slot,
              second_slot: interview.second_slot,
              third_slot: interview.third_slot,
              updated_at: interview.updated_at,
              preferred_slot: interview.preferred_slot,
              is_accepted_by_candidate: interview.is_accepted_by_candidate,
              interviewer: interview.interviewer,
              require_admin_support: interview.require_admin_support,
            }
          end
        end
      end
    end
  end
end
