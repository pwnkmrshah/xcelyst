class Degrees < ActiveRecord::Migration[6.0]
  def change
    create_table :degrees do |t|
      t.string :degree_name
      t.timestamps
    end
  end
end
