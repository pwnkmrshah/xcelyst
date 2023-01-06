class AddColumnsToAdminUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :otp, :integer
    add_column :admin_users, :otp_valid_till, :datetime
    add_column :admin_users, :logged_in, :boolean, default: false
  end
end
