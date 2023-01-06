class AddUserNameToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :user_name, :string
  end
end
