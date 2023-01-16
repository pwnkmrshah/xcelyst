class RemveColumnFromTest < ActiveRecord::Migration[6.0]
  def change
    remove_column :accounts, :test_score_and_course_id
    remove_column :test_score_and_courses, :account_id
  end
end
