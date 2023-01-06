# frozen_string_literal: true

module BxBlockContentManagement
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockContentManagement
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_content_management.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockContentManagement::Engine => base + '/content_management'
      end
    end
  end
end
