class AddProfiletodegreeEducationalQualifications < ActiveRecord::Migration[6.0]
  def change
    add_column :degree_educational_qualifications, :profile_id, :integer
    add_column :educational_qualification_field_study, :profile_id, :integer
  end
end