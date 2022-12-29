class AddColumnToTestScoreAndCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :test_score_and_courses, :role_id, :bigint
  end
end
