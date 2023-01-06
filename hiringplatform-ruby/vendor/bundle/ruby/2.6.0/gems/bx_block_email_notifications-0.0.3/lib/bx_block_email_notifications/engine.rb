# frozen_string_literal: true

module BxBlockEmailNotifications
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockEmailNotifications
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_email_notifications.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockEmailNotifications::Engine => base + '/email_notifications'
      end
    end
  end
end
