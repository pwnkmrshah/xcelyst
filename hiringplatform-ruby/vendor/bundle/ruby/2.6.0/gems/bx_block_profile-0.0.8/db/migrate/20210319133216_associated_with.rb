class AssociatedWith < ActiveRecord::Migration[6.0]
  def change
     create_table :associateds do |t|
      t.string :associated_with_name
      t.timestamps
    end
  end
end
