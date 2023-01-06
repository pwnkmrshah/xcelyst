class AddColumnTestScore < ActiveRecord::Migration[6.0]
  def change
    add_column :test_score_and_courses, :test_id, :integer
    add_column :test_score_and_courses, :test_url, :string
  end
end
