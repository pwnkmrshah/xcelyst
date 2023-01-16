FactoryBot.define do
  factory :privacy_setting, :class => 'BxBlockPrivacySettings::PrivacySetting' do
    account
    latest_activity {true}
    older_activity {false}
    in_app_notification {true}
    chat_notification {true}
    friend_request {true}
    interest_received {true}
    viewed_profile {true}
    off_all_notification {false}
  end
end
