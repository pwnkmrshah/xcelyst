class AddProfiletocurrentAnnualSalarie < ActiveRecord::Migration[6.0]
  def change
  end
     add_column :current_annual_salaries, :profile_id, :integer
end
