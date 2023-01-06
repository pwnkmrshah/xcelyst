# frozen_string_literal: true

module BxBlockCategories
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockCategories
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_categories.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockCategories::Engine => base + '/categories'
      end
    end
  end
end
