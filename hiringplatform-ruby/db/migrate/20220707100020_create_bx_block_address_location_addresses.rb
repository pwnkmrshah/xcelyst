class CreateBxBlockAddressLocationAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :location_addresses do |t|
      t.string :country
      t.text :address
      t.string :email
      t.string :phone
      t.integer :order

      t.timestamps
    end
  end
end
