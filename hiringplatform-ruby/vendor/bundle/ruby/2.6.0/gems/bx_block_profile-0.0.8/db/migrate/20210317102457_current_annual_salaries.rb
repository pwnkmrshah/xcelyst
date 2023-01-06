class CurrentAnnualSalaries < ActiveRecord::Migration[6.0]
  def change
    create_table :current_annual_salaries do |t|
      t.string :current_annual_salary
      t.timestamps
    end
  end
end
