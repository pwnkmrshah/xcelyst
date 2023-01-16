class Conversations < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations do |t|
      t.string :conversation_sid, null: false
      t.string :unique_name, null: false
      t.string :friendly_name
      t.string :url
      t.bigint :client_id, null: false, foreign_key: true
      t.bigint :candidate_id, null: false, foreign_key: true
      t.string :client_sid, null: false
      t.string :candidate_sid, null: false
    end
  end
end
