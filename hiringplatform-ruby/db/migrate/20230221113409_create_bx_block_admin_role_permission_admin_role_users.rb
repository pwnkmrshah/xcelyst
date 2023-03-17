class CreateBxBlockAdminRolePermissionAdminRoleUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_role_users do |t|
      t.references :admin_role, foreign_key: { to_table: :admin_roles, on_delete: :restrict }, type: :bigint
      t.references :admin_user, foreign_key: true
      t.timestamps
    end
  end
end