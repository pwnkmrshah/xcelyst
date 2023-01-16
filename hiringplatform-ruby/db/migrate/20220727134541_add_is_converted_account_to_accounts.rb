class AddIsConvertedAccountToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :is_converted_account, :boolean, default: false
  end
end
