# This migration comes from bx_block_job_listing (originally 20210726120757)
class AddColumnsToCompanyPagesTable < ActiveRecord::Migration[6.0]
  def change
    add_column :company_pages, :headquarters, :string
    add_column :company_pages, :founded, :date
    add_column :company_pages, :specialities, :text
  end
end
