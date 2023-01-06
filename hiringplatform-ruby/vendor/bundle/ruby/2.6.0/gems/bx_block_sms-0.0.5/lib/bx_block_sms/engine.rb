# frozen_string_literal: true

module BxBlockSms
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockSms
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_sms.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockSms::Engine => base + '/sms'
      end
    end
  end
end
