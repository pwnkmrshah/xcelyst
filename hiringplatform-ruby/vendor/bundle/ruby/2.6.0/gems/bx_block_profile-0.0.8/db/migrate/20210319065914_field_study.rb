class FieldStudy < ActiveRecord::Migration[6.0]
  def change
    create_table :field_study do |t|
      t.string :field_of_study
      t.timestamps
    end
  end
end
