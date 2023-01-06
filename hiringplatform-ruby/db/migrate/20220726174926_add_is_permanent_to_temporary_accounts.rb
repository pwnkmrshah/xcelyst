class AddIsPermanentToTemporaryAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :temporary_accounts, :is_permanent, :boolean, default: false
  end
end
