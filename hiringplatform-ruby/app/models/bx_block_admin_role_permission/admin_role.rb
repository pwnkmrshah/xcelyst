module BxBlockAdminRolePermission
  class AdminRole < ApplicationRecord
    self.table_name = :admin_roles

    has_many :admin_role_permissions, class_name: "BxBlockAdminRolePermission::AdminRolePermission", foreign_key: 'admin_role_id', dependent: :destroy

    has_many :admin_permissions, class_name: "BxBlockAdminRolePermission::AdminPermission", foreign_key: 'admin_role_permission_id', through: :admin_role_permissions
    belongs_to :admin_user, optional: true
    accepts_nested_attributes_for :admin_role_permissions
  end
end
