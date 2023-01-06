# frozen_string_literal: true

module BxBlockProfileBio
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockProfileBio
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_profile_bio.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockProfileBio::Engine => "#{base}/profile_bio"
      end
    end
  end
end
