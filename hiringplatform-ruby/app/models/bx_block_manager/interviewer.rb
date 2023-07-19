module BxBlockManager
    class Interviewer < ApplicationRecord
        self.table_name = :interviewers
        validates_presence_of :name, :email, presence: true
        # validates_format_of :name, :with => /^[a-zA-Z\s]*$/, :multiline => true, message: "Number or special character not allowed"
        # validates :email, email_format: { message: 'Invalid email format' }
        validates :email, :uniqueness => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
        validate :name_pattern
        has_many :schedule_interviews, class_name: "BxBlockScheduling::ScheduleInterview"
        belongs_to :client, class_name: "AccountBlock::Account", foreign_key: "client_id", optional: true
        validate :email_valid

      def email_valid
        if Manager.find_by(email: self.email).present?
          errors.add(:email, "and manager email can not be same. A manager is already present with same email.")
        end
      end

      def name_pattern
        valid_name = /^[a-zA-Z\s]*$/

        unless name.match?(valid_name)
          errors.add(:name, 'is invalid. Numbers or special characters are not allowed.')
        end
      end
    end
end
