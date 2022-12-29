class AddProfiletocareerExperiences < ActiveRecord::Migration[6.0]
  def change
    add_column :career_experience_employment_types, :profile_id, :integer
    add_column :career_experience_system_experiences, :profile_id, :integer
    add_column :career_experience_industry, :profile_id, :integer

  end
end