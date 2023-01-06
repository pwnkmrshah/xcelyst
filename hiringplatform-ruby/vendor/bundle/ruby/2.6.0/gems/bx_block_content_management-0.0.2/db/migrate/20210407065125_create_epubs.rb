class CreateEpubs < ActiveRecord::Migration[6.0]
  def change
    create_table :epubs do |t|
      t.string :heading
      t.text :description, size: :long
      t.timestamps
    end
  end
end
