class CreateBxBlockPushNotificationsPushNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :push_notifications do |t|
      t.references :account, foreign_key: true
      t.references :push_notificable,
        polymorphic: true,
        null: false,
        index: {
          name: :index_push_notification_type_and_id
        }
      t.string :remarks
      t.boolean :is_read, default: false

      t.timestamps
    end
  end
end
