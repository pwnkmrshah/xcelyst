class CreateDomainCategory < ActiveRecord::Migration[6.0]
  def change
    create_table :domain_categories do |t|
      t.string :name
      t.references :domain, null: false, foreign_key: true
      t.timestamps
    end
  end
end
