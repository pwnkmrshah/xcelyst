# This migration comes from bx_block_job_listing (originally 20210408091414)
class CompanyPageCompanyTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :company_page_company_types do |t|
      t.integer :company_page_id
      t.integer :company_type_id
      t.timestamps
    end
  end
end