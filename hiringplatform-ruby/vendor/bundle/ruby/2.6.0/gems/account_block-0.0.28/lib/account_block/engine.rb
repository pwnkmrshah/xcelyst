# frozen_string_literal: true

module AccountBlock
  class Engine < ::Rails::Engine
    isolate_namespace AccountBlock
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'account_block.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount AccountBlock::Engine => base + '/account'
      end
    end
  end
end
