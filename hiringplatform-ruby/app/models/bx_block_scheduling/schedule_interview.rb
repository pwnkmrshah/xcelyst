module BxBlockScheduling
  class ScheduleInterview < ApplicationRecord
    self.table_name = :schedule_interviews

    VALITD_INTERVIEW_TYPE = ["video_interview", "hiring_manger_assessment", "hr_assessment"]

    belongs_to :candidate, class_name: "AccountBlock::Account", foreign_key: "account_id"
    belongs_to :client, class_name: "AccountBlock::Account", foreign_key: "client_id"
    belongs_to :job_description, class_name: "BxBlockJobDescription::JobDescription", foreign_key: "job_description_id"
    belongs_to :role, class_name: "BxBlockRolesPermissions::Role", foreign_key: "role_id"
    belongs_to :interviewer, class_name: "BxBlockManager::Interviewer", foreign_key: "interviewer_id"
    
    has_one :zoom_meeting, class_name: 'BxBlockCfzoomintegration3::ZoomMeeting', dependent: :destroy

    validates :first_slot, presence: true, :unless => Proc.new { |a| a.require_admin_support == true }
    validates :preferred_slot, inclusion: { in: %w(first second third) }, :allow_nil => true
    validates_presence_of :time_zone
    validates :interview_type, inclusion: { in: VALITD_INTERVIEW_TYPE }

    validate :all_ready_scheduled, on: :create

    after_create :create_notification_for_create
    after_update :create_notification_for_update

    def create_notification_for_create
      client_name = self.client.user_full_name
      role = self.job_description.role.name
      user = self.candidate
      notification = BxBlockNotifications::Notification.create(
          created_by: self.client_id,
          headings: "Please select the Time Slot",
          contents: "",
          account_id: user.id,
          notificable_id: self.id,
          notificable_type: "BxBlockScheduling::ScheduleInterview",
          is_read: false,
          notification_type: "select_interview_slot"
      )
      components = [
            {"type": "header", "parameters": [{ "type": "text", "text": "#{user.user_full_name}"}],
            },
            {"type": "body", "parameters": [{"type": "text", "text": "#{role}"},{ "type": "text", "text": "#{client_name}"}]
            }]
      BxBlockTwilio::ChatTwilio.send_whatspp_message(user, "choose_candidate_interview_slot_template", components)
    end

    def create_notification_for_update
      if self.preferred_slot.present? && !self.feedback.present?
        client_name = self.client.user_full_name
        role = self.job_description.role.name
        notification = BxBlockNotifications::Notification.create(
            created_by: self.client_id,
            headings: "Interview Time Slot selected successfully",
            contents: "",
            account_id: self.account_id,
            notificable_id: self.id,
            notificable_type: "BxBlockScheduling::ScheduleInterview",
            is_read: false,
            notification_type: "interview_slot_selected"
        )
      end
    end

    def first_slot_end_time
      self.first_slot + 30.minute
    end

    def second_slot_end_time
      self.second_slot + 30.minute
    end

    def third_slot_end_time
      self.third_slot + 30.minute
    end

    private

    def all_ready_scheduled
      shedule_interview = ScheduleInterview.where(client_id: self.client_id, job_description_id: self.job_description_id, account_id: self.account_id)
      shedule_interview.present? && shedule_interview.map do |interview|
        if check_shedule(interview)
          return self.errors.add(:base, "Already Interview Scheduled on that Time")
        end
      end
      interviewer_schedule = ScheduleInterview.where(client_id: self.client_id, interviewer: self.interviewer)
      interviewer_schedule.present? && interviewer_schedule.map do |interview|
        if check_shedule(interview)
          return self.errors.add(:base, "Interviewer Already has Scheduled Interview on that Time")
        end
      end
    end

    def check_shedule(interview)
      if interview.is_accepted_by_candidate
        query = interview.preferred_slot + "_slot"
        slot = interview[query]
        unless (slot + 30.minute < self.first_slot || slot > self.first_slot_end_time) && (slot + 30.minute < self.second_slot || slot > self.second_slot_end_time) && (slot + 30.minute < self.third_slot || slot > self.third_slot_end_time)
          return true
        end
      else
        unless (interview.first_slot + 30.minute < self.first_slot || interview.first_slot > self.first_slot_end_time) && (interview.first_slot + 30.minute < self.second_slot || interview.first_slot > self.second_slot_end_time) && (interview.first_slot + 30.minute < self.third_slot || interview.first_slot > self.third_slot_end_time)
          return true
        end
        unless (interview.second_slot + 30.minute < self.first_slot || interview.second_slot > self.first_slot_end_time) && (interview.second_slot + 30.minute < self.second_slot || interview.second_slot > self.second_slot_end_time) && (interview.second_slot + 30.minute < self.third_slot || interview.second_slot > self.third_slot_end_time)
          return true
        end
        unless (interview.third_slot + 30.minute < self.third_slot || interview.third_slot > self.first_slot_end_time) && (interview.third_slot + 30.minute < self.second_slot || interview.third_slot > self.second_slot_end_time) && (interview.third_slot + 30.minute < self.third_slot || interview.third_slot > self.third_slot_end_time)
          return true
        end
      end
    end
  end
end
