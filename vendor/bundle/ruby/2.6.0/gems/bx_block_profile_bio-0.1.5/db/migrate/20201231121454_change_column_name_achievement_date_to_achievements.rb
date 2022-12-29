# frozen_string_literal: true

class ChangeColumnNameAchievementDateToAchievements < ActiveRecord::Migration[6.0]
  def change
    rename_column :achievements, :calendar, :achievement_date
  end
end
