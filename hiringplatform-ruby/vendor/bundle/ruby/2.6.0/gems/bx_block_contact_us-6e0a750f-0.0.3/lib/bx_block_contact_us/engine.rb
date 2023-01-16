# frozen_string_literal: true

module BxBlockContactUs
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockContactUs
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_contact_us.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockContactUs::Engine => base + '/contact_us'
      end
    end
  end
end
