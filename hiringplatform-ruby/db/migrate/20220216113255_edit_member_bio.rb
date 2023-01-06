class EditMemberBio < ActiveRecord::Migration[6.0]
  def change
    remove_column :members_bios, :social_media_links
    add_column :members_bios, :facebook_link, :string
    add_column :members_bios, :linkedin_link, :string
    add_column :members_bios, :twitter_link, :string
  end
end
