class ChangeReviewsToCatalogueReviews < ActiveRecord::Migration[6.0]
  def change
    rename_table :reviews, :catalogue_reviews
  end
end
