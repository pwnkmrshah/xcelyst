class AddOtpToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :otp, :integer
    add_column :accounts, :otp_valid_till, :datetime
  end
end
