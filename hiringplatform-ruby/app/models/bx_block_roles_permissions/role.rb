module BxBlockRolesPermissions
  class Role < ApplicationRecord
    self.table_name = :roles
    # has_many :accounts, class_name: 'AccountBlock::Account', dependent: :destroy
    # serialize :managers, Array
    validates_presence_of :name, :position, presence: true
    belongs_to :account, class_name: "AccountBlock::Account"
    has_many :test_score_and_courses, class_name: "BxBlockProfile::TestScoreAndCourse", foreign_key: "role_id"
    has_one :job_description, class_name: "BxBlockJobDescription::JobDescription", dependent: :destroy
    has_many :applied_jobs, class_name: "BxBlockRolesPermissions::AppliedJob", dependent: :destroy
    has_many :save_jobs, dependent: :destroy, class_name: "BxBlockSaveJob::SaveJob"
    validates :name, presence: true
  end
end
