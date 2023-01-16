class CreateBxBlockDatabaseTemporaryUserProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :temporary_user_profiles do |t|
      t.references :temporary_user_database, null: false, foreign_key: true
      t.text :work_experience, array: true, default: []
      t.text :skills, array: true, default: []
      t.string :head_line
      t.text :courses, array: true, default: []
      t.text :education, array: true, default: []
      t.string :languages, array: true, default: []
      t.text :certificates, array: true, default: []
      t.string :organizations

      t.timestamps
    end
  end
end
