module BxBlockCalendar
    class InterviewSchedule < BxBlockContactUs::ApplicationRecord
      self.table_name = :interview_schedules      
      belongs_to :applied_jobs, class_name: "BxBlockRolesPermissions::AppliedJob", foreign_key: "applied_job_id"
    end
end
  