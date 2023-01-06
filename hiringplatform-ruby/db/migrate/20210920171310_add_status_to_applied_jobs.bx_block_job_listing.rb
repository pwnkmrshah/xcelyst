# This migration comes from bx_block_job_listing (originally 20210521065108)
class AddStatusToAppliedJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :applied_jobs, :status, :string, :default => 'pending'
  end
end
