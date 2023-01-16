class AddInterviewerRefrenceToScheduleInterview < ActiveRecord::Migration[6.0]
  def change
    remove_column :schedule_interviews, :interviewer
    add_reference :schedule_interviews, :interviewer, foreign_key: true
  end
end
