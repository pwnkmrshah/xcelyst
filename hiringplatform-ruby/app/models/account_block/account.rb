module AccountBlock
  class Account < AccountBlock::ApplicationRecord
    self.table_name = :accounts

    include Wisper::Publisher

    has_secure_password
    # before_validation :parse_full_phone_number
    # before_create :generate_api_key
    # has_one :blacklist_user, class_name: 'AccountBlock::BlackListUser', dependent: :destroy
    # after_save :set_black_listed_user
    # before_create :set_default_value
    has_one_attached :avatar
    before_create :generate_pin_and_valid_date
    before_save { self.email.downcase! }
    # after_create :send_pin_via_sms
    # validates_format_of :first_name, :last_name, :with => /^[a-zA-Z\s]*$/, :multiline => true, message: "Number or special character not allowed"
    # "." is present in last_name so we are removing "*$" made_by_sadhna
    validates_format_of :first_name, :last_name, :with => /^[a-zA-Z\s]/, :multiline => true, message: "Number or special character not allowed"
    validates_format_of :current_city, :with => /^[a-zA-Z\s()]*$/, :multiline => true, message: "Number or special character not allowed"
    validates_presence_of :first_name, :last_name, :current_city, :email, presence: true
    # validates_presence_of :resume_url, present: true, if: -> { self.user_role == "candidate"}
    validates :email, :uniqueness => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
    validates :phone_number, presence: true, if: -> {self.user_role == 'candidate'}
    validates_uniqueness_of :phone_number, if: -> {self.user_role == 'candidate'}
    validates :user_role, presence: true, inclusion: { in: %w(client candidate) }
    has_one :profile, class_name: "BxBlockProfile::Profile", dependent: :destroy
    has_one :user_resume, class_name: "AccountBlock::UserResume", dependent: :destroy

    has_many :candidate_zoom_meetings, class_name: 'BxBlockCfzoomintegration3::ZoomMeeting', dependent: :destroy, foreign_key: :candidate_id
    has_many :client_zoom_meetings, class_name: 'BxBlockCfzoomintegration3::ZoomMeeting', dependent: :destroy, foreign_key: :client_id
    has_many :roles, class_name: "BxBlockRolesPermissions::Role", dependent: :destroy
    has_many :managers, class_name: "BxBlockManager::Manager", dependent: :destroy
    has_many :user_preferred_skills, class_name: "AccountBlock::UserPreferredSkill", dependent: :destroy
    has_many :client_jd_shortlisting, class_name: "BxBlockShortlisting::ShortlistingCandidate", foreign_key: "client_id", dependent: :destroy
    has_many :client_conversations, class_name: "BxBlockTwilio::Conversation", foreign_key: "client_id", dependent: :destroy
    has_many :candidate_conversations, class_name: "BxBlockTwilio::Conversation", foreign_key: "client_id", dependent: :destroy
    has_many :favourite_converstions, class_name: "BxBlockTwilio::FavouriteConverstion"
    has_many :shortlisting_candidate, class_name: "BxBlockShortlisting::ShortlistingCandidate", foreign_key: "candidate_id", dependent: :destroy
    has_many :client_jd_shortlisting, class_name: "BxBlockShortlisting::ShortlistingCandidate", foreign_key: "client_id", dependent: :destroy
    has_many :schedule_interviews, class_name: "BxBlockScheduling::ScheduleInterview", foreign_key: "client_id", dependent: :destroy
    has_many :interviewers, class_name: "BxBlockManager::Interviewer", foreign_key: "client_id", dependent: :destroy
    has_many :notifications, class_name: "BxBlockNotifications::Notification", dependent: :destroy, foreign_key: "account_id"
    has_one_attached :resume_image, dependent: :destroy

    has_many :test_accounts, class_name: "BxBlockProfile::TestAccount", foreign_key: "account_id"
    has_many :test_score_and_courses, class_name: "BxBlockProfile::TestScoreAndCourse", foreign_key: "test_score_and_course_id", :through => :test_accounts
    has_many :applied_jobs, through: :profile, class_name: "BxBlockRolesPermissions::AppliedJob"

    has_many :send_messages, -> { where(sender_type: "AccountBlock::Account") }, as: :sender, class_name: "BxBlockWhatsapp::WhatsappMessage", dependent: :destroy
    has_many :receive_messages, -> { where(receiver_type: "AccountBlock::Account") }, as: :receiver, class_name: "BxBlockWhatsapp::WhatsappMessage", dependent: :destroy
    has_many :whatsapp_chats, -> {where(user_type: "AccountBlock::Account")}, as: :user, foreign_key: "user_id" ,class_name: "BxBlockWhatsapp::WhatsappChat", dependent: :destroy

    
    scope :candidates, -> { where(user_role: 'candidate') }
    scope :clients, -> { where(user_role: 'client') }

    def generate_pin_and_valid_date
      self.otp = rand(1_00000..9_99999)
      self.otp_valid_till = Time.current + 5.minutes
    end

    def user_full_name
      "#{self.first_name} #{self.last_name}"
    end

    private

    def set_default_value
      self.activated = true if self.activated == false
    end

    def send_pin_via_sms
      message = "Your Pin Number is #{self.otp}"
      txt = BxBlockSms::SendSms.new("+#{self.full_phone_number}", message)
      txt.call
    end

    def parse_full_phone_number
      phone = Phonelib.parse(full_phone_number)
      self.full_phone_number = phone.sanitized
      self.country_code = phone.country_code
      self.phone_number = phone.raw_national
    end

    def valid_phone_number
      unless Phonelib.valid?(full_phone_number)
        errors.add(:full_phone_number, "Invalid or Unrecognized Phone Number")
      end
    end

    def generate_api_key
      loop do
        @token = SecureRandom.base64.tr("+/=", "Qrt")
        break @token unless Account.exists?(unique_auth_id: @token)
      end
      self.unique_auth_id = @token
    end

    def set_black_listed_user
      if is_blacklisted_previously_changed?
        if is_blacklisted
          AccountBlock::BlackListUser.create(account_id: id)
        else
          blacklist_user.destroy
        end
      end
    end
  end
end
