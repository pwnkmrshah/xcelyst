class CreateDomain < ActiveRecord::Migration[6.0]
  def change
    create_table :domains do |t|
      t.string :name
      t.timestamps
      
    end
  end
end
