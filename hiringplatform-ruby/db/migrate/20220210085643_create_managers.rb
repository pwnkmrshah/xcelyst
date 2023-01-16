class CreateManagers < ActiveRecord::Migration[6.0]
  def change
    create_table :managers do |t|
      t.string :name
      t.string :email
      t.references :account, null: false, foreign_key: true
    end
  end
end
