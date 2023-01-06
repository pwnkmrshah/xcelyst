module BxBlockPrivacySettings
  class PrivacySettingSerializer < BuilderBase::BaseSerializer
    attributes *[
      :account_id
    ]

    attribute :full_name do |object|
      account = object.account
      [account&.first_name, account&.last_name].join(" ")
    end
  end
end
