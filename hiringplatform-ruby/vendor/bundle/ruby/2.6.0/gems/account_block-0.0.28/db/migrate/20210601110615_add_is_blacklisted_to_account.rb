class AddIsBlacklistedToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :is_blacklisted, :boolean, :default => false
  end
end
