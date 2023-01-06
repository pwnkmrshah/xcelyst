class RemoveColumnsProfileBioIdAndStatusFromFavourites < ActiveRecord::Migration[6.0]
  def change
    remove_column :favourites, :profile_bio_id
    remove_column :favourites, :status
  end
end
