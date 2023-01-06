class CreateBxBlockSaveJobSaveJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :save_jobs do |t|
      t.references :role, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true
      t.boolean :favourite
      t.timestamps
    end
  end
end
