class ExperienceIndustry < ActiveRecord::Migration[6.0]
  def change
     create_table :career_experience_industry do |t|
      t.integer :career_experience_id
      t.integer :industry_id
      t.timestamps
    end
  end
end
