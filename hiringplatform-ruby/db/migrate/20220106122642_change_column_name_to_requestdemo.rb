class ChangeColumnNameToRequestdemo < ActiveRecord::Migration[6.0]
  def change
    remove_column :request_demos, :full_name, :string
    add_column :request_demos, :first_name, :string
    add_column :request_demos, :last_name, :string
  end
end
