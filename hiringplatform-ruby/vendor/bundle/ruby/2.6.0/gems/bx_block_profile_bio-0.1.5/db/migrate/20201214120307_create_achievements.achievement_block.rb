# frozen_string_literal: true

class CreateAchievements < ActiveRecord::Migration[6.0]
  def change
    create_table :achievements do |t|
      t.string :title
      t.date :calendar
      t.text :detail
      t.string :url
      t.integer :profile_bio_id

      t.timestamps
    end
  end
end
