# This migration comes from bx_block_job_listing (originally 20210426103458)
class RenameColumnAplliedJobToAppliedJob < ActiveRecord::Migration[6.0]
  def change
    rename_column :applied_jobs, :apllied_job_title, :applied_job_title
  end
end
