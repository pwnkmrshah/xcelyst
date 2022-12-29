class CreatePodcasts < ActiveRecord::Migration[6.0]
  def change
    create_table :audio_podcasts do |t|
      t.string :heading
      t.string :description
      t.timestamps
    end
  end
end
