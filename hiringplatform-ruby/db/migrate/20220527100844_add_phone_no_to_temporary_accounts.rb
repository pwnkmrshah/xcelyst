class AddPhoneNoToTemporaryAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :temporary_accounts, :phone_no, :string
  end
end
