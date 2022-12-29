module BxBlockProfile
  class TestScoreAndCourse < BxBlockProfile::ApplicationRecord
    self.table_name = :test_score_and_courses
    belongs_to :profile, class_name: "BxBlockProfile::Profile",  optional: true
    has_one  :test_accounts ,class_name: 'BxBlockProfile::TestAccount', foreign_key: 'test_score_and_course_id'
    has_one  :account, :through => :test_accounts, class_name: "AccountBlock::Account", foreign_key: 'account_id'

    # belongs_to :role, class_name: 'BxBlockRolesPermissions::Role'
  end
end
