module BxBlockManager
    class Manager < BxBlockContactUs::ApplicationRecord
      self.table_name = :managers
      validates_presence_of :name, :email, presence: true
      validates :email, :uniqueness => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
      belongs_to :account, class_name: "AccountBlock::Account"
      validate :email_valid

      def email_valid
        if Interviewer.find_by(email: self.email).present?
          errors.add(:email, "and interviewer email can not be same. An interviewer is already present with same email.")
        end
      end
    end
  end
  