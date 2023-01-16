# frozen_string_literal: true

module BxBlockPaymentAdmin
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockPaymentAdmin
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_payment_admin.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockPaymentAdmin::Engine => base + '/payment_admin'
      end
    end
  end
end
