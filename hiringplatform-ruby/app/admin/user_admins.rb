ActiveAdmin.register UserAdmin do
  menu label: "Admin User", priority: 3
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('user admin') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
  end

  permit_params :email, :password, :password_confirmation,admin_role_user_attributes: [:id, :admin_role_id]

  # Remove the buttons from the show page
  config.action_items.delete_if { |item| item.display_on?(:show) }
  # Then add in our own conditional Edit Button

  index do
    selectable_column
    id_column
    column :email
    column :admin_role do |admin_user|
      admin_user.admin_role_user&.admin_role&.name
    end
    column :actions do |object|
      links = []
      links << link_to('Show', [:admin, object], class: "button")
      if (current_user_admin.is_admin? || current_user_admin.id == object.id)
        links << link_to('Edit', [:edit, :admin, object], class: "button") if current_user_admin.can_edit_admin_user?(current_user_admin)
      end
      if (object.role != 'super admin') && (object.id != current_user_admin.id)
        links << link_to('Delete', [:admin, object], class: "button", method: :delete, confirm: 'Are you sure you want to delete this?')  if current_user_admin.can_delete_admin_user?(current_user_admin)
      end
      links.join(' ').html_safe
    end
  end

  show do
    attributes_table do
      row :id
      row :email
      row :admin_role do |admin_user|
        admin_user.admin_role_user&.admin_role&.name
      end
      row :current_sign_in_at
      row :sign_in_count
      row :created_at
      row '2Factor Authentication' do |object|
        object.enable_2FA
      end
    end
    active_admin_comments
  end

  filter :email

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin_role, label: 'Role', as: :select, collection: BxBlockAdminRolePermission::AdminRole.all.map {|r| [r.name, r.id]} if current_user_admin.is_admin?
      f.input :enable_2FA, as: :boolean
    end
    f.actions
  end
  controller do
    include ActiveAdmin::BatchActionsHelper

    def create
      admin_user = UserAdmin.new(admin_params)
      if admin_user.save
        admin_role_id = params[:user_admin][:admin_role_id].presence
        if admin_role_id.present?
          admin_user.create_admin_role_user(admin_role_id: admin_role_id)
        end
        redirect_to admin_user_admins_path, notice: 'Admin role created successfully.'
      else
        redirect_to new_admin_user_admin_path, alert: 'Admin role not created.'
      end
    end

    def update
      admin_user = UserAdmin.find(params[:id])
      if admin_user.update(admin_params)
        admin_role_id = params[:user_admin][:admin_role_id].presence
        if admin_role_id.present?
          admin_user.create_admin_role_user(admin_role_id: admin_role_id)
        end
        redirect_to admin_user_admins_path, notice: 'Admin role updated successfully.'
      else
        redirect_to edit_admin_user_admin_path(admin_user), alert: admin_user.errors.full_messages.first
      end
    end

    private
    def admin_params
      params.require(:user_admin).permit(:email, :password, :password_confirmation, :enable_2FA, admin_role_user_attributes: [:id, :admin_role_id])
    end

  end
end

