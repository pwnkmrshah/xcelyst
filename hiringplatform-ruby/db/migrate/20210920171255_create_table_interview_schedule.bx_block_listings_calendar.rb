# This migration comes from bx_block_listings_calendar (originally 20210504122924)
class CreateTableInterviewSchedule < ActiveRecord::Migration[6.0]
  def change
    create_table :interview_schedules do |t|
      t.string :event_title
      t.string :event_description
      t.string :joinee_name
      t.boolean :reminder , default: false
      t.integer :applied_job_id
      t.integer :profile_id
      t.integer :invitation_type
      t.datetime :schedule_date
      t.timestamps
    end
  end
end
