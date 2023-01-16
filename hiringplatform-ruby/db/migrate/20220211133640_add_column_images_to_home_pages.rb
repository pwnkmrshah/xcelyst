class AddColumnImagesToHomePages < ActiveRecord::Migration[6.0]
  def change
    add_column :home_pages, :image, :string
    add_column :home_pages, :active, :boolean, default: false
  end
end
