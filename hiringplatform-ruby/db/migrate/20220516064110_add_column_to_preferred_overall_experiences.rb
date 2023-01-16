class AddColumnToPreferredOverallExperiences < ActiveRecord::Migration[6.0]
  def change
    add_column :preferred_overall_experiences, :minimum_experience, :integer
    add_column :preferred_overall_experiences, :maximum_experience, :integer
  end
end
