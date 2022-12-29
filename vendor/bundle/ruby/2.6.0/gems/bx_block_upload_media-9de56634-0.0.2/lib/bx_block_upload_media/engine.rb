# frozen_string_literal: true

module BxBlockUploadMedia
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockUploadMedia
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_upload_media.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockUploadMedia::Engine => base + '/upload_media'
      end
    end
  end
end
