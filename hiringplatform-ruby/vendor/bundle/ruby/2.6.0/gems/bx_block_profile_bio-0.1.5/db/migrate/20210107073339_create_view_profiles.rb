# frozen_string_literal: true

class CreateViewProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :view_profiles do |t|
      t.integer :profile_bio_id
      t.integer :view_by_id

      t.timestamps
    end
  end
end
