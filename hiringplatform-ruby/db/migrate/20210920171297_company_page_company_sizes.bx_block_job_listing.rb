# This migration comes from bx_block_job_listing (originally 20210408091228)
class CompanyPageCompanySizes < ActiveRecord::Migration[6.0]
  def change
    create_table :company_page_company_sizes do |t|
      t.integer :company_page_id
      t.integer :company_size_id
      t.timestamps
    end
  end
end
