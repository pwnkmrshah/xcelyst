class CreatePreferredOverallExperience < ActiveRecord::Migration[6.0]
  def change
    create_table :preferred_overall_experiences do |t|
      t.string :experiences_year
      t.string :level
      t.string :grade 
    end
  end
end
