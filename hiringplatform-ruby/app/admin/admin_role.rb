ActiveAdmin.register BxBlockAdminRolePermission::AdminRole, as: "Admin Role" do
  menu parent: "User Management", label: "Role Management", priority: 1

  permit_params :name, admin_permission_ids: []

  index do
    id_column
    column :name
    actions
  end

  show do
    div class: "show-page-container" do
      h2 "Role: #{BxBlockAdminRolePermission::AdminRole.find(params[:id]).name}"

      admin_role = BxBlockAdminRolePermission::AdminRole.find(params[:id])
      admin_role_permissions = admin_role.admin_role_permissions
      admin_permissions = BxBlockAdminRolePermission::AdminPermission.all
      module_names = admin_permissions.pluck(:module_name).uniq

      module_names.each do |module_name|
        div class: "module-container" do
          div class: "module-name" do
            h3 module_name.humanize
          end
          div class: "permission-container" do
            div class: "permission-list" do
              admin_permissions.where(module_name: module_name).each do |permission|
                div class: "permission-row" do
                  input type: "checkbox", disabled: true, checked: admin_role_permissions.map(&:admin_permission_id).include?(permission.id)
                  label permission.name.humanize
                  br
                end
              end
            end
          end
        end
        br
        br
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name, as: :string
      admin_permissions = BxBlockAdminRolePermission::AdminPermission.all
      module_names = admin_permissions.pluck(:module_name).uniq

      module_names.each do |module_name|
        div class: "module-container" do
          div class: "module-name" do
            h3 module_name.humanize
          end
          div do
            div do
              content_tag :a, "Select All", href: "#", class: "select-all-permission", data: {module_name: module_name}
            end
            # div do
            #   permissions = BxBlockAdminRolePermission::AdminPermission.where(module_name: module_name).pluck(:name, :id)
            #   f.input "admin_permission_ids", as: :check_boxes, collection: permissions, label: false, :input_html => {:class => 'role_permissions', "data-module_name" => module_name} 
            # end
            div class: "permission-container" do
              div class: "permission-list" do
                div class: "permission-row" do
                  permissions = BxBlockAdminRolePermission::AdminPermission.where(module_name: module_name).pluck(:name, :id)
                  permissions = permissions.map do |str, num|
                    [str.capitalize.tr("_", " "), num]
                  end
                  f.input "admin_permission_ids", as: :check_boxes, collection: permissions, label: false, :input_html => {:class => 'role_permissions', "data-module_name" => module_name} 
                end
              end
            end
          end
          
        end
        br
        br
      end

    end
    f.actions
  end

  controller do
    def create
      admin_role = BxBlockAdminRolePermission::AdminRole.new(admin_role_params)
      if admin_role.save
        params[:bx_block_admin_role_permission_admin_role][:admin_permission_ids].each do |id|
          admin_role.admin_role_permissions.create(admin_permission_id: id)
        end
        redirect_to admin_admin_roles_path, message: 'Admin role created successfully.'
      else
        redirect_to new_admin_admin_role_path, error: 'Admin role not created.'
      end
    end

    def update
      super
      resource.admin_role_permissions.delete_all
      params[:bx_block_admin_role_permission_admin_role][:admin_permission_ids].each do |id|
        resource.admin_role_permissions.create(admin_permission_id: id)
      end if params[:bx_block_admin_role_permission_admin_role][:admin_permission_ids].present?
    end

    private

    def admin_role_params
       params.require(:bx_block_admin_role_permission_admin_role).permit(:name)
    end
  end
end
