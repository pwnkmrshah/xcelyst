class AddIdentifierToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :identifier, :integer
    BxBlockCategories::BuildCategories.call
  end
end
