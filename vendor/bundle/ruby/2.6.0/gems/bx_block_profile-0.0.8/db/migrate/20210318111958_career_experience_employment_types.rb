class CareerExperienceEmploymentTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :career_experience_employment_types do |t|
      t.integer :career_experience_id
      t.integer :employment_type_id
      t.timestamps
    end
  end
end
