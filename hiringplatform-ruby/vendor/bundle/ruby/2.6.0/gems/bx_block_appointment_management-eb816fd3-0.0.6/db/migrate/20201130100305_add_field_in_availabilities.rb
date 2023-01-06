class AddFieldInAvailabilities < ActiveRecord::Migration[6.0]
  def change
    add_column :availabilities, :available_slots_count, :integer
  end
end
