# frozen_string_literal: true

module BxBlockLike
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockLike
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_like.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockLike::Engine => base + '/like'
      end
    end
  end
end
