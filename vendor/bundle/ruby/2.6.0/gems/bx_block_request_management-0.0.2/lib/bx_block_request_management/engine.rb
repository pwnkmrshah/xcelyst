# frozen_string_literal: true

module BxBlockRequestManagement
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockRequestManagement
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_request_management.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockRequestManagement::Engine => base + '/request_management'
      end
    end
  end
end
