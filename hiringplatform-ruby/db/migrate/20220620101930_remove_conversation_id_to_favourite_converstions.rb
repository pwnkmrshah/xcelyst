class RemoveConversationIdToFavouriteConverstions < ActiveRecord::Migration[6.0]
  def change
    remove_column :favourite_converstions, :conversation_id
  end
end
