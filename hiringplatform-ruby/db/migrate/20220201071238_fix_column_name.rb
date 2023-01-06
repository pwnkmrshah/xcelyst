class FixColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :audio_podcasts, :audio, :audio_url
    rename_column :content_videos, :videos, :video_url
  end
end
