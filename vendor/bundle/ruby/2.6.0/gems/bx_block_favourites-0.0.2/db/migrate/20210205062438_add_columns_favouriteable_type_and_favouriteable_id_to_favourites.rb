class AddColumnsFavouriteableTypeAndFavouriteableIdToFavourites < ActiveRecord::Migration[6.0]
  def change
    add_column :favourites, :favouriteable_id, :integer
    add_column :favourites, :favouriteable_type, :string
  end
end
