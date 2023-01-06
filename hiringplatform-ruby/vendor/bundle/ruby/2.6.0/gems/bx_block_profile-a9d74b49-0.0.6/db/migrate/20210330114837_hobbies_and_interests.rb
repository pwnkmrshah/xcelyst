class HobbiesAndInterests < ActiveRecord::Migration[6.0]
  def change
    create_table :hobbies_and_interests do |t|
      t.string :title
      t.string :category
      t.text :description
      t.boolean :make_public, :null => false, :default => false
      t.integer :profile_id
      t.timestamps
    end
  end
end
