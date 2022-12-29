# frozen_string_literal: true

module BxBlockLanguageOptions
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockLanguageOptions
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_language_options.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockLanguageOptions::Engine => base + '/language_options'
      end
    end
  end
end
