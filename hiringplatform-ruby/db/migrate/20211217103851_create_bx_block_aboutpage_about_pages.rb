class CreateBxBlockAboutpageAboutPages < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_aboutpage_about_pages do |t|
      t.string :title
      t.text :description
      t.string :image
      t.timestamps
    end 
  end
end
