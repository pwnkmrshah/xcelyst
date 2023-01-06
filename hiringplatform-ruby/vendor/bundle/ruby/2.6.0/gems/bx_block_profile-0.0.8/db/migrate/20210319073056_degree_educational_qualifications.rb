class DegreeEducationalQualifications < ActiveRecord::Migration[6.0]
  def change
    create_table :degree_educational_qualifications do |t|
      t.integer :educational_qualification_id
      t.integer :degree_id
      t.timestamps
    end
  end
end
