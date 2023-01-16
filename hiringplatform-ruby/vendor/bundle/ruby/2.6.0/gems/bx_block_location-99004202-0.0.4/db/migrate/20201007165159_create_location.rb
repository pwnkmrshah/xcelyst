class CreateLocation < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.float :latitude
      t.float :longitude
      t.integer :van_id
    end
  end
end
