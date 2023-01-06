class CreateBusinessCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :business_categories do |t|
      t.string :name
      t.references :business_domain, null: false, foreign_key: true
      t.timestamps
    end
  end
end
