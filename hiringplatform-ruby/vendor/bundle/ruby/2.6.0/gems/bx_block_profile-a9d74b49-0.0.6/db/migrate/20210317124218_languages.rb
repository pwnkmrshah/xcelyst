class Languages < ActiveRecord::Migration[6.0]
  def change
    create_table :languages do |t|
      t.string :language
      t.string :proficiency
      t.integer :profile_id

      t.timestamps
    end
  end
end
