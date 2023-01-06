# This migration comes from bx_block_job_listing (originally 20210408062247)
class CompanyPageIndustries < ActiveRecord::Migration[6.0]
  def change
    create_table :company_page_industries do |t|
      t.integer :company_page_id
      t.integer :industry_id
      t.timestamps
    end
  end
end
