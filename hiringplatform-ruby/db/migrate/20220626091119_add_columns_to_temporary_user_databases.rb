class AddColumnsToTemporaryUserDatabases < ActiveRecord::Migration[6.0]
  def change
    add_column :temporary_user_databases, :photo_url, :jsonb
    add_column :temporary_user_databases, :contacts, :jsonb
    add_column :temporary_user_databases, :social_url, :jsonb

    remove_column :temporary_user_databases, :position
    add_column :temporary_user_databases, :position, :jsonb

  end
end
