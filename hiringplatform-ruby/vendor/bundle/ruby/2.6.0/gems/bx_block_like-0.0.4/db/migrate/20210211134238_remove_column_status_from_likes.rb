class RemoveColumnStatusFromLikes < ActiveRecord::Migration[6.0]
  def change
    remove_column :likes, :status
  end
end
