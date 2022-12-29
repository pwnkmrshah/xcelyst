class AddImagesToContentText < ActiveRecord::Migration[6.0]
  def change
    add_column :content_texts, :images, :string, array: true, default: []
    add_column :audio_podcasts, :image, :string
    add_column :audio_podcasts, :audio, :string
    add_column :epubs, :pdfs, :string, array: true, default: []
    add_column :content_videos, :videos, :string
    add_column :content_videos, :image, :string
  end
end
