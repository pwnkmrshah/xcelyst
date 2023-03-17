class AddUserAdminRefToAdminRoleUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :admin_role_users, :user_admin, foreign_key: true
  end
end
