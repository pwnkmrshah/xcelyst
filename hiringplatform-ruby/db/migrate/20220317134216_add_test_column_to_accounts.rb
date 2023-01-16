class AddTestColumnToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :test_score_and_course_id, :integer
  end
end
