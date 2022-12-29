class ChangeColumnToAccount < ActiveRecord::Migration[6.0]
  def change
    change_column :accounts, :phone_number, :string
  end
end
