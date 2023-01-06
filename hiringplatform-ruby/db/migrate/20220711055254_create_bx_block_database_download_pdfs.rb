class CreateBxBlockDatabaseDownloadPdfs < ActiveRecord::Migration[6.0]
  def change
    create_table :download_pdfs do |t|
      t.references :temporary_user_database, null: false, foreign_key: true
      t.string :ip_address
      t.string :mac_address
      t.datetime :download_on

      t.timestamps
    end
  end
end
