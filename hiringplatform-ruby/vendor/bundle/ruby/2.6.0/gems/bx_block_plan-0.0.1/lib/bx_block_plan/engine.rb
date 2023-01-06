# frozen_string_literal: true

module BxBlockPlan
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockPlan
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_plan.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockPlan::Engine => base + '/plan'
      end
    end
  end
end
