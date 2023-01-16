# frozen_string_literal: true

module BxBlockSettings
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockSettings
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_settings.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockSettings::Engine => base + '/settings'
      end
    end
  end
end
