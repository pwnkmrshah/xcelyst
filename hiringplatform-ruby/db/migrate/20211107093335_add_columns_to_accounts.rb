class AddColumnsToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :current_city, :string
    add_column :accounts, :user_role, :string
    add_column :accounts, :resume, :binary
  end
end