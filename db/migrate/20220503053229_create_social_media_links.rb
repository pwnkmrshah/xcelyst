class CreateSocialMediaLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :social_media_links do |t|
      t.string :title
      t.string :link
      t.timestamps
    end
  end
end
