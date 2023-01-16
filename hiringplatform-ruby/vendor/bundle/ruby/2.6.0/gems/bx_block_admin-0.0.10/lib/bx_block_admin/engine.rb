# frozen_string_literal: true

module BxBlockAdmin
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockAdmin
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_admin.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockAdmin::Engine => base + '/admin'
      end
    end
  end
end
