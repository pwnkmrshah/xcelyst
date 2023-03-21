class AddEnbale2FaToUserAdmin < ActiveRecord::Migration[6.0]
  def change
    add_column :user_admins, :enable_2FA, :boolean, default: false
  end
end
