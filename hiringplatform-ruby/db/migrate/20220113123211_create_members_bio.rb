class CreateMembersBio < ActiveRecord::Migration[6.0]
  def change
    create_table :members_bios do |t|
      t.string :name
      t.text :description
      t.string :position
      t.string :social_media_links, array: true, default: []
      t.references :content_type, null: false, foreign_key: true
      t.timestamps
    end
  end
end
