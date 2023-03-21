class AddUniqueIndexToAdminPermissions < ActiveRecord::Migration[6.0]
  def change
    add_index :admin_permissions, [:module_name, :name], unique: true
  end
end
