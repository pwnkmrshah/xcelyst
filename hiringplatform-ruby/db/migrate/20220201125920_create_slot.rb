class CreateSlot < ActiveRecord::Migration[6.0]
  def change
    create_table :slot do |t|
      t.references :interview_schedule, null: false, foreign_key: true
      t.datetime :schedule_date
    end
  end
end
