# frozen_string_literal: true

module BxBlockPayments
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockPayments
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_payments.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockPayments::Engine => base + '/payments'
      end
    end
  end
end
