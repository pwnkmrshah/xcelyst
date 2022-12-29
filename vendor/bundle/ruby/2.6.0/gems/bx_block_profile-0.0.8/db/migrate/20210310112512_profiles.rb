class Profiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.string :country
      t.string :address
      t.string :postal_code
      t.integer :account_id
      t.string :photo
      t.timestamps
    end
  end
end
