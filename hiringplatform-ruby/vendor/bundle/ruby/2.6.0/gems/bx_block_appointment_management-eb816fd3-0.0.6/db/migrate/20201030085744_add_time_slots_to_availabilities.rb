class AddTimeSlotsToAvailabilities < ActiveRecord::Migration[6.0]
  def change
    add_column :availabilities, :timeslots, :jsonb
  end
end
