class AddImagesToMemberBio < ActiveRecord::Migration[6.0]
  def change
    add_column :members_bios, :image, :string
  end
end
