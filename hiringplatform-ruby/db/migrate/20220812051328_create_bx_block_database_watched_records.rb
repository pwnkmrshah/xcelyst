class CreateBxBlockDatabaseWatchedRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :watched_records do |t|
      t.references :temporary_user_database, null: false, foreign_key: true
      t.string :ip_address

      t.timestamps
    end
  end
end
