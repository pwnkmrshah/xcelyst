class CreateTestAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :test_accounts do |t|
      t.references :account, null: false, foreign_key: true
      t.references :test_score_and_course, null: false, foreign_key: true
    end
  end
end
