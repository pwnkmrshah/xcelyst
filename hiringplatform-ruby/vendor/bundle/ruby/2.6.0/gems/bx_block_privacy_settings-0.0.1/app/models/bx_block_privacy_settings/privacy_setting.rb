# frozen_string_literal: true

module BxBlockPrivacySettings
  class PrivacySetting < BxBlockPrivacySettings::ApplicationRecord
    self.table_name = :privacy_settings
    include Wisper::Publisher

    belongs_to :account, class_name: 'AccountBlock::Account'
  end
end
