# frozen_string_literal: true

class AddTypeToPushNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :push_notifications, :notify_type, :string
  end
end
