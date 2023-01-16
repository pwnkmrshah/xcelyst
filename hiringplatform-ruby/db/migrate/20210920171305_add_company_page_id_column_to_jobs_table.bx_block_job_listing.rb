# This migration comes from bx_block_job_listing (originally 20210423104058)
class AddCompanyPageIdColumnToJobsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :company_page_id, :integer
  end
end
