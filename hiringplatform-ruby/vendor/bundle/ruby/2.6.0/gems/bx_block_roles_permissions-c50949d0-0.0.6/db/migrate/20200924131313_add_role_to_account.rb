class AddRoleToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :role_id, :integer
  end
end
