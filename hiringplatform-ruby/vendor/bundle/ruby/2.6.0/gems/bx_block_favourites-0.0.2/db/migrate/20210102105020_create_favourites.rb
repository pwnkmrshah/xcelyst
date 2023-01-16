class CreateFavourites < ActiveRecord::Migration[6.0]
  def change
    create_table :favourites do |t|
      t.integer :profile_bio_id
      t.integer :favourite_by_id
      t.integer :status, default: 1

      t.timestamps
    end
  end
end
