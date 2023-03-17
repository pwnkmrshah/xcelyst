class AddEnable2FaToAdminUser < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :enable_2FA, :boolean, default: false
  end
end
