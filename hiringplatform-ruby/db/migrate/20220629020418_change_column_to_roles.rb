class ChangeColumnToRoles < ActiveRecord::Migration[6.0]
  def up
    change_column :roles, :managers, :text, array: true, default: [], using: "(string_to_array(managers, ','))"
  end

  def down
    change_column :roles, :managers, :text, array: false, default: {}, using: "(array_to_string(managers, ','))"
  end
end
