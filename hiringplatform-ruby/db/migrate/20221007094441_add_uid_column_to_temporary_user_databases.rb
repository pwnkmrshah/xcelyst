class AddUidColumnToTemporaryUserDatabases < ActiveRecord::Migration[6.0]
  def change
    add_column :temporary_user_databases, :uid, :string
  end
end
