class AddProfiletodegree < ActiveRecord::Migration[6.0]
  def change
    add_column :degrees, :profile_id, :integer
    add_column :employment_types, :profile_id, :integer
    add_column :field_study, :profile_id, :integer
 end
end
