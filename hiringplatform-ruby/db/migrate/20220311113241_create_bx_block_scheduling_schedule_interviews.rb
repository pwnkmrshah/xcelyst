class CreateBxBlockSchedulingScheduleInterviews < ActiveRecord::Migration[6.0]
  def change
    create_table :schedule_interviews do |t|
      t.references :account, null: false, foreign_key: true
      t.references :job_description, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.datetime :first_slot
      t.datetime :second_slot
      t.datetime :third_slot
      t.boolean :require_admin_support, default: false
      t.string :preferred_slot
      t.boolean :is_accepted_by_candidate, default: false
      t.boolean :request_alt_slots, default: false

      t.timestamps
    end
  end
end
