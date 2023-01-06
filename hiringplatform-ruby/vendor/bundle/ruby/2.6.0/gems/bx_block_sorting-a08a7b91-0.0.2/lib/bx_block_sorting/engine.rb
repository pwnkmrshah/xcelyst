# frozen_string_literal: true

module BxBlockSorting
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockSorting
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_sorting.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockSorting::Engine => base + '/sorting'
      end
    end
  end
end
