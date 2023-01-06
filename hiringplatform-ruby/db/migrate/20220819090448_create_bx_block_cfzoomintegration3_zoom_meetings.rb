class CreateBxBlockCfzoomintegration3ZoomMeetings < ActiveRecord::Migration[6.0]
  def change
    create_table :zoom_meetings do |t|
      t.bigint :candidate_id, null: false
      t.bigint :client_id, null: false
      t.references :zoom, null: false, foreign_key: true
      t.datetime :schedule_date
      t.string :starting_at
      t.string :ending_at
      t.jsonb :meeting_urls

      t.timestamps
    end
  end
end
