# frozen_string_literal: true

module BxBlockAddress
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockAddress
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_address.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockAddress::Engine => base + '/address'
      end
    end
  end
end
