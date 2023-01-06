class CreateBxBlockPreferredRolePreferredSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :preferred_skills do |t|
      t.string :name

      t.timestamps
    end
    add_index :preferred_skills, :name
  end
end
