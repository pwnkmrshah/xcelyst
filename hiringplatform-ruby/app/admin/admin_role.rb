ActiveAdmin.register BxBlockAdminRolePermission::AdminRole, as: "Admin Role" do
  menu parent: "User Management", label: "Role Management", priority: 1

  permit_params :name, admin_permission_ids: []

  index do
    id_column
    column :name
    actions
  end

  show do
    render 'admin/show_admin_roles'
  end

  form partial: 'admin/admin_roles'

  controller do
    def create
      admin_role = BxBlockAdminRolePermission::AdminRole.new(admin_role_params)
      if admin_role.save

        params[:bx_block_admin_role_permission_admin_role][:admin_permission_ids].each do |id|
          admin_role.admin_role_permissions.create(admin_permission_id: id)
        end
        flash[:notice] = 'Admin role updated successfully.'
        redirect_to admin_admin_roles_path
      else
        flash[:error] = 'Admin role not created.'
        redirect_to new_admin_admin_role_path
      end
    end

    def update
      admin_role = BxBlockAdminRolePermission::AdminRole.find(params[:id])

      if admin_role.update(admin_role_params)
        admin_role.admin_role_permissions.delete_all
         params[:bx_block_admin_role_permission_admin_role][:admin_permission_ids].each do |id|
          admin_role.admin_role_permissions.create(admin_permission_id: id)
        end if params[:bx_block_admin_role_permission_admin_role][:admin_permission_ids].present?
        flash[:notice] = 'Admin role updated successfully.'
        redirect_to admin_admin_role_path(admin_role)
      else
        flash[:error] = 'Admin role not updated.'
        redirect_to edit_admin_admin_role_path(admin_role)
      end
    end

    private

    def admin_role_params
       params.require(:bx_block_admin_role_permission_admin_role).permit(:name)
    end
  end
end
