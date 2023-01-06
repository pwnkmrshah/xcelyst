# frozen_string_literal: true

module BxBlockRolesPermissions
  class Engine < ::Rails::Engine
    isolate_namespace BxBlockRolesPermissions
    config.generators.api_only = true

    config.builder = ActiveSupport::OrderedOptions.new

    initializer 'bx_block_roles_permissions.configuration' do |app|
      base = app.config.builder.root_url || ''
      app.routes.append do
        mount BxBlockRolesPermissions::Engine => base + '/roles_permissions'
      end
    end
  end
end
