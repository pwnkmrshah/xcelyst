module BxBlockRolesPermissions
  class AppliedJob < ApplicationRecord
    self.table_name = :applied_jobs
    # default_scope :include => :account, :order => "created_at DS"
    belongs_to :profile, class_name: "BxBlockProfile::Profile"
    has_one :account, through: :profile, class_name: "AccountBlock::Account"
    belongs_to :role, class_name: "BxBlockRolesPermissions::Role"
    belongs_to :shortlisting_candidate, class_name: "BxBlockShortlisting::ShortlistingCandidate", dependent: :destroy
    has_many :interview_feedbacks, class_name: "BxBlockFeedback::InterviewFeedback", foreign_key: "applied_jobs_id", dependent: :destroy
    has_many :interview_schedules, class_name: "BxBlockCalendar::InterviewSchedule", foreign_key: "applied_job_id", dependent: :destroy
    validates :role_id, :profile_id, presence: true
    VALITD_STATUS = ["accepted", "pending", "rejected"]
    validates :status, inclusion: { in: VALITD_STATUS }
    validate :allready_applied, on: :create

    def assessment_staged
      score = 0
      assessment_staged = {}
      assessment_staged["shortlisted"] = self.shortlisting_candidate&.shortlisted_by_admin == "true"
      assessment_staged["test"] = false
      assessment_staged["interview"] = false
      tests = self.account.test_score_and_courses
      tests.present? && tests.each do |test|
        if test.role_ids.include?(self.role.id) && test.score.present?
          assessment_staged["test"] = true
          break
        end
      end
      schedule_interviews = BxBlockScheduling::ScheduleInterview.where(role_id: self.role.id, account_id: self.profile.account_id)
      schedule_interviews.present? && schedule_interviews.map do |schedule_interview|
        zoom_meeting = schedule_interview&.zoom_meeting
        if zoom_meeting && zoom_meeting.feedback_nofi_status.present?
            assessment_staged["interview"] = true
            break
        end
      end
      assessment_staged["final_score"] = self.final_score.present?
      assessment_staged['status'] = self.accepted
      return assessment_staged
    end

    def get_solt(interview)
      if interview.is_accepted_by_candidate
        query = interview.preferred_slot + "_slot"
        slot = interview[query]
      end
    end

    private

    def allready_applied
      if AppliedJob.exists?(role_id: self.role_id, profile_id: self.profile_id)
        errors.add(:base, "You all ready applied for this job")
      end
    end
  end
end
