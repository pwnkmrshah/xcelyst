# frozen_string_literal: true

module BxBlockCustomUserSubs
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockCustomUserSubs
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_custom_user_subs.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockCustomUserSubs::Engine =>
                  base + '/customisable_user_subscriptions'
      end
    end
  end
end
