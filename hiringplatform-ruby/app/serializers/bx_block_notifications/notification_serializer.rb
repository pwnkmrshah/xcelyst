module BxBlockNotifications
  class NotificationSerializer
    include FastJsonapi::ObjectSerializer
    attributes *[
        :id,
        :created_by,
        :headings,
        :contents,
        :app_url,
        :is_read,
        :notificable_type,
        :read_at,
        :notification_type,
        :created_at,
        :updated_at
    ]

    attribute :notificable do |obj|
      case obj.notificable_type
      when "BxBlockShortlisting::ShortlistingCandidate"
        role = obj.notificable.job_description.role
        {
          role: role.name,
          job_id: role.job_description.id,
          role_id: role.id,
          client: role.account.user_full_name
        }
      when "BxBlockFeedback::InterviewFeedback"
        role = obj.notificable.applied_jobs.role
        {
          role: role.name,
          role_id: role.id,
          client: role.account.user_full_name,
          applied_job_id:  obj.notificable.applied_jobs.id
        }
      when "BxBlockScheduling::ScheduleInterview"
        notificable = obj.notificable
        role = obj.notificable.job_description.role
        {
          role: role.name,
          role_id: role.id,
          client: role.account.user_full_name,
          created_at: notificable.created_at,
          id: notificable.id,
          interviewer: notificable.interviewer.id,
          is_accepted_by_candidate: notificable.is_accepted_by_candidate,
          preferred_slot: notificable.preferred_slot,
          require_admin_support: notificable.require_admin_support,
          first_slot: notificable.first_slot,
          second_slot: notificable.second_slot,
          third_slot: notificable.third_slot,
          updated_at: notificable.updated_at
        }
      end
    end

  end
end
