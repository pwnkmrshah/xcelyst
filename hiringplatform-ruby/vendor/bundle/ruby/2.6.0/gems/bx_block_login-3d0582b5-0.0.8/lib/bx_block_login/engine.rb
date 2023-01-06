# frozen_string_literal: true

module BxBlockLogin
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockLogin
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_login.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockLogin::Engine => base + '/login'
      end
    end
  end
end
