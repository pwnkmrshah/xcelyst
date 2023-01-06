module BxBlockPrivacySettings
  class NotificationSettingSerializer < BuilderBase::BaseSerializer
    attributes *[
      :account_id,
      :in_app_notification,
      :chat_notification,
      :friend_request,
      :interest_received,
      :viewed_profile,
      :off_all_notification
    ]
  end
end
