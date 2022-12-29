# This migration comes from bx_block_listings_calendar (originally 20210524100903)
class CreateRescheduleInterview < ActiveRecord::Migration[6.0]
  def change
    create_table :reschedule_interviews do |t|
      t.integer :interview_schedule_id
      t.datetime :reschedule_date
      t.text :reason
      t.timestamps
    end
  end
end
