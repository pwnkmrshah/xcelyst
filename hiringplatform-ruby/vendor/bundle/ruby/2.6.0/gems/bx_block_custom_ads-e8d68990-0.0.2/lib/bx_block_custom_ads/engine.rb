# frozen_string_literal: true

module BxBlockCustomAds
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockCustomAds
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_custom_ads.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockCustomAds::Engine => base + '/custom_ads'
      end
    end
  end
end
