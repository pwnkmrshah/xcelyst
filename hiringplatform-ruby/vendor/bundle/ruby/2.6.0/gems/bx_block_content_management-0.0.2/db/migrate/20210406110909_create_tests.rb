class CreateTests < ActiveRecord::Migration[6.0]
  def change
    create_table :tests do |t|
      t.text :description, size: :long
      t.string :headline
      t.timestamps
    end
  end
end
