# frozen_string_literal: true

module BxBlockCors
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockCors
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_cors.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockCors::Engine => base + '/cors'
      end
    end
  end
end
