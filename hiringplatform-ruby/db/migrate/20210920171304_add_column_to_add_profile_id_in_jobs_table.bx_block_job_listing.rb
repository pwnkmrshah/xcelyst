# This migration comes from bx_block_job_listing (originally 20210414094311)
class AddColumnToAddProfileIdInJobsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :profile_id, :integer
  end
end
