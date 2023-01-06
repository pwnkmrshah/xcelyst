# frozen_string_literal: true

module BxBlockCatalogue
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockCatalogue
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_catalogue.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockCatalogue::Engine => base + '/catalogue'
      end
    end
  end
end
