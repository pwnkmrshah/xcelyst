# frozen_string_literal: true

module BxBlockPushNotifications
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockPushNotifications
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_push_notifications.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockPushNotifications::Engine => base + '/push_notifications'
      end
    end
  end
end
