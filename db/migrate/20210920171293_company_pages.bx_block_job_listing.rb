# This migration comes from bx_block_job_listing (originally 20210407114307)
class CompanyPages < ActiveRecord::Migration[6.0]
  def change
    create_table :company_pages do |t|
      t.string :company_name
      t.string :website
      t.string :company_tagline
      t.string :country
      t.string :address
      t.string :postal_code
      t.integer :profile_id
      t.timestamps
    end
  end
end
