class CreateBxBlockAdminRolePermissionAdminRolePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_role_permissions do |t|
      t.references :admin_role
      t.references :admin_permission
      t.timestamps
    end
  end
end
