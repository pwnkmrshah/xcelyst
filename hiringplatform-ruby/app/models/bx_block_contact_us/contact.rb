module BxBlockContactUs
  class Contact < BxBlockContactUs::ApplicationRecord
    self.table_name = :contacts
    
    EMAIL_REGEX = /[^@]+[@][\S]+[.][\S]+/.freeze

    belongs_to :account, class_name: "AccountBlock::Account", optional: true

    validates :name, :email,:phone_number,:description, presence: true
    validates :email, :format => {with: EMAIL_REGEX }
    validates_format_of :name, :with => /^[a-zA-Z\s]*$/, :multiline => true, message: "Number or special character not allowed"
    validates_format_of :phone_number, :with =>  /\d[0-9]\)*\z/ , :message => "Only number allowed"
    #validate :valid_email, if: Proc.new { |c| c.email.present? }
    #validate :valid_phone_number, if: Proc.new { |c| c.phone_number.present? }
    def valid_phone_number
      validator = Phonelib.valid?(phone_number)
      errors.add(:phone_number, "invalid") if !validator.valid?
    end

    def user_full_name
      name
    end
  
    def self.filter(query_params)
      ContactFilter.new(self, query_params).call
    end

    private

    # def valid_email
    #   validator = AccountBlock::EmailValidation.new(email)
    #   errors.add(:email, "invalid") if !validator.valid?
    # end

    # def valid_phone_number
    #   validator = AccountBlock::PhoneValidation.new(phone_number)
    #   errors.add(:phone_number, "invalid") if !validator.valid?
    # end
  end
end
