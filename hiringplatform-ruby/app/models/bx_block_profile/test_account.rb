module BxBlockProfile
  class TestAccount < BxBlockProfile::ApplicationRecord
    self.table_name = :test_accounts
    belongs_to :account  , class_name: "AccountBlock::Account", foreign_key: 'account_id'
    belongs_to :test_score_and_course, class_name: "BxBlockProfile::TestScoreAndCourse", foreign_key: 'test_score_and_course_id'
  end
end
