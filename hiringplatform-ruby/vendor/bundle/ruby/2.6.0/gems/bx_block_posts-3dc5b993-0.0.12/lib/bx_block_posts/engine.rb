# frozen_string_literal: true
module BxBlockPosts
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockPosts
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_posts.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockPosts::Engine => base + '/posts'
      end
    end
  end
end
