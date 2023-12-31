class CreateAccountBlockUserPreferredSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :user_preferred_skills do |t|
      t.references :account, null: false, foreign_key: true
      t.references :preferred_skill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
