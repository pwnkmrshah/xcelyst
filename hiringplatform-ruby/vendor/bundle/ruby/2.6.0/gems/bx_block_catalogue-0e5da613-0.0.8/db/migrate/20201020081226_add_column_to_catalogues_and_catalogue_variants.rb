class AddColumnToCataloguesAndCatalogueVariants < ActiveRecord::Migration[6.0]
  def change
    add_column :catalogues, :block_qty, :integer
    add_column :catalogue_variants, :block_qty, :integer
  end
end
