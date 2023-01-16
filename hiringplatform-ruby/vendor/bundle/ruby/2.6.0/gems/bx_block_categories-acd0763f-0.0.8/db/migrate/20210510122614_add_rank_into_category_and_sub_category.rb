class AddRankIntoCategoryAndSubCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :rank, :integer
    add_column :sub_categories, :rank, :integer
  end
end
