# frozen_string_literal: true

module BxBlockAdvancedSearch
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockAdvancedSearch
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_advanced_search.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockAdvancedSearch::Engine => base + '/advanced_search'
      end
    end
  end
end
