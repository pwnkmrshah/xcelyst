# frozen_string_literal: true

require 'wisper'

module BxBlockPrivacySettings
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockPrivacySettings
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_privacy_settings.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockPrivacySettings::Engine => "#{base}/privacy_settings"
      end
    end
  end
end

# Added Account Listener to catch the broadcast message whenever account is created
class AccountListener
  def account_created(account_id)
    BxBlockPrivacySettings::PrivacySetting.create(account_id: account_id.id)
  end
end

# Whisper will automatically trigger the listener under scope
Wisper.subscribe(
  AccountListener.new,
  scope: [
    'AccountBlock::Account'
  ]
)
