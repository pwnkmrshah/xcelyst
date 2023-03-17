class CreateBxBlockAdminRolePermissionAdminPermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_permissions do |t|
      t.string :module_name
      t.string :name
      t.timestamps
    end
  end
end
