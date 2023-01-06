class CreateFavouriteConverstion < ActiveRecord::Migration[6.0]
  def change
    create_table :favourite_converstions do |t|
      t.references :conversation, null: false, foreign_key: :true
      t.string :sid
      t.references :account, null: false, foreign_key: true
    end
  end
end
