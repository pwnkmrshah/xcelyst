# This migration comes from bx_block_job_listing (originally 20210409102724)
class RemoveColumnFromCompanyPageTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :company_pages, :profile_id
  end
end
