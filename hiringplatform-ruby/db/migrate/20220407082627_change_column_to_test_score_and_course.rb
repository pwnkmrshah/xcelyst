class ChangeColumnToTestScoreAndCourse < ActiveRecord::Migration[6.0]
  def change
    remove_column :test_score_and_courses, :role_id
    add_column :test_score_and_courses, :role_ids, :integer, array: true, default: []
  end
end
