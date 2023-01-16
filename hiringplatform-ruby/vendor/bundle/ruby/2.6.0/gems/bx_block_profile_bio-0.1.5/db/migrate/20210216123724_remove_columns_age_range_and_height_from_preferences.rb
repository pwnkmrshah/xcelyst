# frozen_string_literal: true

class RemoveColumnsAgeRangeAndHeightFromPreferences < ActiveRecord::Migration[6.0]
  def change
    remove_column :preferences, :age_range
    remove_column :preferences, :height
  end
end
