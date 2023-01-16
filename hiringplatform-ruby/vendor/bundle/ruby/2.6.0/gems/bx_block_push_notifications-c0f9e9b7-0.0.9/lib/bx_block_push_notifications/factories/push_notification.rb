FactoryBot.define do
  factory :push_notification, :class => 'BxBlockPushNotifications::PushNotification' do
    remarks { "John has started following you." }
    is_read { false }
  end
end

