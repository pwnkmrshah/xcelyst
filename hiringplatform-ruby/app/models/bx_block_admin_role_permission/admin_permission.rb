module BxBlockAdminRolePermission
  class AdminPermission < ApplicationRecord
    self.table_name = :admin_permissions

    has_many :admin_role_permissions, class_name: "BxBlockAdminRolePermission::AdminRolePermission", foreign_key: 'admin_role_id', dependent: :destroy

    has_many :admin_roles, class_name: "BxBlockAdminRolePermission::AdminRole", foreign_key: 'admin_role_permission_id', through: :admin_role_permissions

  end
end
