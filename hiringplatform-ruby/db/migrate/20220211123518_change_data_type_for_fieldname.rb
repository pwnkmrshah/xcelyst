class ChangeDataTypeForFieldname < ActiveRecord::Migration[6.0]
  def change
    change_column :home_pages, :description, :text
  end
end
