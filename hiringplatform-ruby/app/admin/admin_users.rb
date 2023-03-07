ActiveAdmin.register AdminUser do
  # menu label: "Admin User", priority: 3

  permit_params :email, :password, :password_confirmation, :admin_role, :otp, admin_role_user_attributes: [:id, :admin_role_id]

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
      f.inputs 'Admin Role' do
        f.fields_for :admin_role_user, f.object.admin_role_user || BxBlockAdminRolePermission::AdminRoleUser.new do |r|
          r.input :admin_role, label: 'Role', as: :select, collection: BxBlockAdminRolePermission::AdminRole.all.map {|r| [r.name, r.id]}
        end
      end
    end
    f.actions
  end

  controller do
    def create
      admin_user = AdminUser.new(admin_params)
      if admin_user.save
        admin_role_id = params[:admin_user][:admin_role_user_attributes][:admin_role_id]
        admin_user.create_admin_role_user(admin_role_id: admin_role_id)
        redirect_to admin_admin_users_path, message: 'Admin role created successfully.'
      else
        redirect_to new_admin_admin_user_path, error: 'Admin role not created.'
      end
    end

    private
    def admin_params
       params.require(:admin_user).permit(:email, :password, :password_confirmation)
    end
  end
end
