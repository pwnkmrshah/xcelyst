class AddColumnNotificableToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_reference :notifications, :notificable, polymorphic: true,  index: true
  end
end
