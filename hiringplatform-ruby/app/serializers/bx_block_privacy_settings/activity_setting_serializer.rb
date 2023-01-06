module BxBlockPrivacySettings
  class ActivitySettingSerializer < BuilderBase::BaseSerializer
    attributes *[
      :account_id,
      :latest_activity,
      :older_activity
    ]
  end
end
