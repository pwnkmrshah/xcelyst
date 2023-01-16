# This migration comes from bx_block_job_listing (originally 20210412111918)
class AddCompanyDescriptionColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :company_pages, :company_description, :text
  end
end
