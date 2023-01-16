# frozen_string_literal: true

module BxBlockFavourites
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockFavourites
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_favourites.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockFavourites::Engine => base + '/favourites'
      end
    end
  end
end
