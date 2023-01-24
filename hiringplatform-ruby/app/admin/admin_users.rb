ActiveAdmin.register AdminUser do
  menu label: "Admin User", priority: 3
  permit_params :email, :password, :password_confirmation, admin_role_user_attributes: [:id, :admin_role_id, :_destroy]

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
      f.inputs 'Admin Role' do
        f.fields_for :admin_role_user, f.object.admin_role_user || BxBlockAdminRolePermission::AdminRoleUser.new do |r|
          r.input :admin_role, label: 'Role', as: :select, collection: BxBlockAdminRolePermission::AdminRole.all.map {|r| [r.name, r.id]}
        end
      end
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
