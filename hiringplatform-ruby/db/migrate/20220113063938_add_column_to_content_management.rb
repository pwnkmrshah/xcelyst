class AddColumnToContentManagement < ActiveRecord::Migration[6.0]
  def change
    add_reference :content_texts, :content_type, null: false, foreign_key: true
    add_reference :content_videos, :content_type, null: false, foreign_key: true
    add_reference :audio_podcasts, :content_type, null: false, foreign_key: true
    add_reference :epubs, :content_type, null: false, foreign_key: true
    change_column :content_texts, :content, :text
  end
end
