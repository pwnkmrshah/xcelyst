ActiveAdmin.register BxBlockAdminRolePermission::AdminRole, as: "Admin Role" do
  menu parent: "User Management", label: "Role Management", priority: 1
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('role management') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
  end

  permit_params :name, admin_permission_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :actions do |object|
      links = []
      links << link_to('Show', resource_path(object), class: "button")
      if object.name&.downcase != 'super admin'
        links << link_to('Edit', edit_resource_path(object), class: "button") if current_user_admin.can_edit_role?(current_user_admin)
        links << link_to('Delete', resource_path(object), class: "button", method: :delete, confirm: 'Are you sure you want to delete this?') if current_user_admin.can_delete_role?(current_user_admin)
      end
      links.join(' ').html_safe
    end
  end

  show do
    render 'admin/show_admin_roles'
  end

  form partial: 'admin/admin_roles'

  member_action :enable_candidate, method: :post do
    Rails.logger.info"got inside this method"
    redirect_to edit_resource_path, alert: "It will enable candidate view also. Do you want to continue?"
  end

  controller do
    include ActiveAdmin::BatchActionsHelper
    def create
      admin_permission_ids = params[:bx_block_admin_role_permission_admin_role][:admin_permission_ids]

      # If no permission, then don't save the AdminRole
      unless admin_permission_ids.any? { |id| id != "0" }
        flash[:error] = 'Please select at least one permission to create a new Admin Role!'
        redirect_to new_admin_admin_role_path and return
      end

      admin_role = BxBlockAdminRolePermission::AdminRole.new(admin_role_params)

      if admin_role.save
        admin_permission_ids.each do |id|
          admin_role.admin_role_permissions.create(admin_permission_id: id)
        end
        flash[:notice] = 'Admin role created successfully.'
        redirect_to admin_admin_roles_path
      else
        flash[:error] = 'Admin role not created.'
        redirect_to new_admin_admin_role_path
      end
    end

    def update
      admin_role = BxBlockAdminRolePermission::AdminRole.find(params[:id])
      admin_permission_ids = params[:bx_block_admin_role_permission_admin_role][:admin_permission_ids]

      # If no permission, then don't save the AdminRole
      unless admin_permission_ids.any? { |id| id != "0" }
        flash[:error] = 'Please select at least one permission to create a new Admin Role!'
        redirect_to edit_admin_admin_role_path(admin_role) and return
      end
      begin
        ActiveRecord::Base.transaction do
          admin_role.update(admin_role_params)
          admin_role.admin_role_permissions.delete_all
          admin_permission_ids.each do |id|
            admin_role.admin_role_permissions.create(admin_permission_id: id)
          end
        end
        flash[:notice] = 'Admin role updated successfully.'
        redirect_to admin_admin_role_path(admin_role)
      rescue
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
