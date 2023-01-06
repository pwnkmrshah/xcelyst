class UpdateBxBlockPostPost < ActiveRecord::Migration[6.0]
  def change
    remove_column :posts, :price
    remove_column :posts, :currency
    add_column :posts, :body, :text
    add_column :posts, :location, :string
  end
end
