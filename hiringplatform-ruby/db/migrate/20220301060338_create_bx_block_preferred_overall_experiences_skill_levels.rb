class CreateBxBlockPreferredOverallExperiencesSkillLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :preferred_skill_levels do |t|
      t.string :experiences_year
      t.string :level
      t.timestamps
    end
  end
end
