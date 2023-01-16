class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.integer :account_id
      t.boolean :latest_activity, default: true
      t.boolean :older_activity, default: false
      t.boolean :in_app_notification, default: true
      t.boolean :chat_notification, default: true
      t.boolean :friend_request, default: true
      t.boolean :interest_received, default: true
      t.boolean :viewed_profile, default: true
      t.boolean :off_all_notification, default: false

      t.timestamps
    end
  end
end
