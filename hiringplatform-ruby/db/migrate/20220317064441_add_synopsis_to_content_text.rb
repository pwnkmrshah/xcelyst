class AddSynopsisToContentText < ActiveRecord::Migration[6.0]
  def change  
    add_column :content_texts, :synopsis, :text
  end
end
