class AddColumnToAccout < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :reset_password_token, :string
  end
end
