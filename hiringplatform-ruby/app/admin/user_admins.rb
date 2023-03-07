ActiveAdmin.register UserAdmin do
  menu label: "Admin User", priority: 3

  permit_params :email, :password, :password_confirmation,admin_role_user_attributes: [:id, :admin_role_id]

  index do
    selectable_column
    id_column
    column :email
    column :admin_role do |admin_user|
      admin_user.admin_role_user&.admin_role&.name
    end
    actions
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
    end
    active_admin_comments
  end

  filter :email

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin_role, label: 'Role', as: :select, collection: BxBlockAdminRolePermission::AdminRole.all.map {|r| [r.name, r.id]}
      f.input :otp, as: :boolean
    end
    f.actions
  end
  controller do
    def create
      admin_user = UserAdmin.new(admin_params)
      if admin_user.save
        admin_role_id = params[:user_admin][:admin_role_id].presence
        if admin_role_id.present?
          admin_user.create_admin_role_user(admin_role_id: admin_role_id)
        end
        redirect_to admin_user_admins_path, message: 'Admin role created successfully.'
      else
        redirect_to new_admin_user_admin_path, error: 'Admin role not created.'
      end
    end

    def update
      admin_user = UserAdmin.find(params[:id])
      if admin_user.update(admin_params)
        admin_role_id = params[:user_admin][:admin_role_id].presence
        if admin_role_id.present?

          admin_user.create_admin_role_user(admin_role_id: admin_role_id)

          # admin_user.create_admin_role_user(admin_role_id: admin_role_id)
        end
        redirect_to admin_user_admins_path, message: 'Admin role updated successfully.'
      else
        redirect_to edit_admin_user_admin_path(admin_user), error: 'Admin role not updated.'
      end
    end

    private

def admin_params
  params.require(:user_admin).permit(:email, :password, :password_confirmation, admin_role_user_attributes: [:id, :admin_role_id])
end

  end
end

