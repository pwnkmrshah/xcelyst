class AddColumnToScheduleInterviews < ActiveRecord::Migration[6.0]
  def change
    add_column :schedule_interviews, :client_id, :bigint, null: false
  end
end
