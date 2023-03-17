module BxBlockAdminRolePermission
  class AdminRolePermission < ApplicationRecord
    self.table_name = :admin_role_permissions

    belongs_to :admin_roles, foreign_key: 'admin_role_id', class_name: 'BxBlockAdminRolePermission::AdminRole'
    belongs_to :admin_permissions, foreign_key: 'admin_permission_id', class_name: 'BxBlockAdminRolePermission::AdminPermission'
  end
end
