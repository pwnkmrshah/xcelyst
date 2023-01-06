module BxBlockShortlisting
  class ShortlistingCandidate < ApplicationRecord
    self.table_name = :shortlisting_candidates

    belongs_to :job_description, class_name: "BxBlockJobDescription::JobDescription", foreign_key: "job_description_id"
    belongs_to :client, class_name: "AccountBlock::Account", foreign_key: "client_id"
    belongs_to :candidate, class_name: "AccountBlock::Account", foreign_key: "candidate_id"
    has_one :applied_job, class_name: "BxBlockRolesPermissions::AppliedJob", foreign_key: "shortlisting_candidate_id", dependent: :destroy
    validates_uniqueness_of :candidate, scope: [:job_description, :client]
    validates :shortlisted_by_admin, presence: true

    enum shortlisted_by_admin: %w(true false)

    scope :shortlisted, -> { where(is_shortlisted: true) }
    scope :applied_by_candidate, -> { where(is_applied_by_candidate: true, is_shortlisted: false) }
    scope :shortlisted_candidates, -> (client_id, jd_id){ where(client_id: client_id, job_description_id: jd_id, is_shortlisted: true) }

    after_initialize :set_shortlisted_by_admin
    after_update :create_notification_for_create
    after_create :create_notification_for_create

    # create by punit 
    # create shortlisted notification for candidate
    def create_notification_for_create
      if self.shortlisted_by_admin == "true"
        client_name = self.client.user_full_name
        role = self.job_description.role.name
        user = self.candidate
        nf = BxBlockNotifications::Notification.where(created_by: self.client.id, account_id: user.id, notificable_id: self.id, notificable_type: "BxBlockShortlisting::ShortlistingCandidate", notification_type: "shortlisted_candidates")
        unless nf.present?
          notification = BxBlockNotifications::Notification.create(
              created_by: self.client.id,
              headings: "You are shortlisted",
              account_id: user.id,
              notificable_id: self.id,
              notificable_type: "BxBlockShortlisting::ShortlistingCandidate",
              is_read: false,
              notification_type: "shortlisted_candidates"
          )
            components = [
              {"type": "header", "parameters": [{ "type": "text", "text": "#{user.user_full_name}"}],
              },
              {"type": "body", "parameters": [{"type": "text", "text": "#{role}"},{ "type": "text", "text": "#{client_name}"}]
              }]
            BxBlockTwilio::ChatTwilio.send_whatspp_message(user, "new_candidate_shorlisted_template", components)
        end
      end
    end

    private

    def set_shortlisted_by_admin
      self.shortlisted_by_admin = "true" if self.shortlisted_by_admin.nil?
    end
  end
end
