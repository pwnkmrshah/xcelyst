# frozen_string_literal: true

module BxBlockLocation
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockLocation
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_location.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockLocation::Engine => base + '/location'
      end
    end
  end
end
