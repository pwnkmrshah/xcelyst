class AddCoumnToTestScoreAndCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :test_score_and_courses, :account_id, :integer
  end
end
