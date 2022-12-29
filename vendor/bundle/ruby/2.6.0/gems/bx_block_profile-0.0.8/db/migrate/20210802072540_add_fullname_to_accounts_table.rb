class AddFullnameToAccountsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :full_name, :string, default: nil
  end
end
