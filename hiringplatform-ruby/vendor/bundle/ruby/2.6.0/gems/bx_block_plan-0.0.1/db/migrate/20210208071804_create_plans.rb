# frozen_string_literal: true

class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :duration
      t.float :price
      t.text :details

      t.timestamps
    end
  end
end
