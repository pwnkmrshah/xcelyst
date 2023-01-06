class CreateBxBlockDatabaseDownloadLimits < ActiveRecord::Migration[6.0]
  def change
    create_table :download_limits do |t|
      t.integer :no_of_downloads

      t.timestamps
    end
  end
end
