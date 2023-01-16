class AddColumnToScheduleInterview < ActiveRecord::Migration[6.0]
  def change
    add_column :schedule_interviews, :interviewer, :string
    add_column :schedule_interviews, :interview_type, :string
  end
end
