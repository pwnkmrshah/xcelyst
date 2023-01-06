class AddExpMonthsColumnToTemporaryUserDatabases < ActiveRecord::Migration[6.0]
  def change
    add_column :temporary_user_databases, :experience_month, :int
  end
end
