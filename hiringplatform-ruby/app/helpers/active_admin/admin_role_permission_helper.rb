module ActiveAdmin::AdminRolePermissionHelper

  def admin_permissions
    BxBlockAdminRolePermission::AdminPermission.all
  end

  def module_names
    admin_permissions.pluck(:module_name).uniq
  end

  def module_permissions(module_name)
    admin_permissions.where(module_name: module_name)
  end

  def permission_name(permission)
    permission.name.humanize
  end
  
  def admin_role(id)
    BxBlockAdminRolePermission::AdminRole.find_by(id: id)
  end
end
