# frozen_string_literal: true

module BxBlockFilterItems
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockFilterItems
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_filter_items.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockFilterItems::Engine => base + '/filter_items'
      end
    end
  end
end
