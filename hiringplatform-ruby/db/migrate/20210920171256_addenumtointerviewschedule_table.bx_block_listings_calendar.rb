# This migration comes from bx_block_listings_calendar (originally 20210517113352)
class AddenumtointerviewscheduleTable < ActiveRecord::Migration[6.0]
  def change
    add_column :interview_schedules , :status, :integer, default: 0
  end
end
