class AddColumnTimeZoneToScheduleInterviews < ActiveRecord::Migration[6.0]
  def change
    add_column :schedule_interviews, :time_zone, :string
  end
end
