# frozen_string_literal: true

module BxBlockNotifications
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockNotifications
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_notifications.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockNotifications::Engine => base + '/notifications'
      end
    end
  end
end
