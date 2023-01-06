# frozen_string_literal: true

module BxBlockForgotPassword
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockForgotPassword
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_forgot_password.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockForgotPassword::Engine => base + '/forgot_password'
      end
    end
  end
end
