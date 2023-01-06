class CreateDomainSubCategory < ActiveRecord::Migration[6.0]
  def change
    create_table :domain_sub_categories do |t|
      t.string :name
      t.references :domain_category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
