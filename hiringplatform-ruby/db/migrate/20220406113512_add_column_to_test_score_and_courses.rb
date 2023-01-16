class AddColumnToTestScoreAndCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :test_score_and_courses, :status, :string
    add_column :test_score_and_courses, :invitation_end_date, :string
  end
end
