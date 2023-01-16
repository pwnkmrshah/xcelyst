class AddParentIdIntoSubCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_categories, :parent_id, :bigint
  end
end
