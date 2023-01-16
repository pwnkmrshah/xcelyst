class AddAccountToRoles < ActiveRecord::Migration[6.0]
  def change
    add_reference :roles, :account, null: false, foreign_key: true
    add_column :roles, :position, :integer
    add_column :roles, :managers, :string, array: true, default: []
    add_column :roles, :is_closed, :boolean, default: false
  end
end
