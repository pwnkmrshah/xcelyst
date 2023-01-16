class AddColumnToTempAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :temporary_accounts, :sovren_score, :integer
  end
end
