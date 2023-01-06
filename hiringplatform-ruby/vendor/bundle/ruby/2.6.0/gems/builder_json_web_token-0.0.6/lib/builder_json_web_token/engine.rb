# frozen_string_literal: true

module BuilderJsonWebToken
  class Engine < ::Rails::Engine
    isolate_namespace BuilderJsonWebToken
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'builder_json_web_token.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BuilderJsonWebToken::Engine => base + '/builder_json_web_token'
      end
    end
  end
end
