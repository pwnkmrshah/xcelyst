class CreateBxBlockContentmanagementBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmarks do |t|
      t.references :account, null: false, foreign_key: true
      t.references :content, null: false, foreign_key: true
      t.timestamps
    end
  end
end
