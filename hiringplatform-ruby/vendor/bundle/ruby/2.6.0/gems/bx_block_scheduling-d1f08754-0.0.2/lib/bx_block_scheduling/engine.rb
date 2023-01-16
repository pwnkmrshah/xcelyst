# frozen_string_literal: true

module BxBlockScheduling
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockScheduling
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_scheduling.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockScheduling::Engine => base + '/scheduling'
      end
    end
  end
end
