module BxBlockManager
    class Interviewer < ApplicationRecord
        self.table_name = :interviewers
        validates_presence_of :name, :email, presence: true
        validates_format_of :name, :with => /^[a-zA-Z\s]*$/, :multiline => true, message: "Number or special character not allowed"
        # validates :email, email_format: { message: 'Invalid email format' }
        validates :email, :uniqueness => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
        has_many :schedule_interviews, class_name: "BxBlockScheduling::ScheduleInterview"
        belongs_to :client, class_name: "AccountBlock::Account", foreign_key: "client_id", optional: true
        validate :email_valid

      def email_valid
        if Manager.find_by(email: self.email).present?
          errors.add(:email, "manager Already taken email")
        end
      end

    end
end
