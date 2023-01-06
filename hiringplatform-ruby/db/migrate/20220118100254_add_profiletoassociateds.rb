class AddProfiletoassociateds < ActiveRecord::Migration[6.0]
  def change
    add_column :associateds, :profile_id, :integer
  end
end