class CurrentStatusEmploymentTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :current_status_employment_types do |t|
      t.integer :current_status_id
      t.integer :employment_type_id
      t.timestamps
    end
  end
end
