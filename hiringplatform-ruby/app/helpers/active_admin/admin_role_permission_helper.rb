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

  def module_name_checked(obj, module_name, permission_ids = [])
    return nil if obj.new_record?

    admin_permission_ids = obj.admin_permission_ids
    (permission_ids - admin_permission_ids).empty?
  end
end
