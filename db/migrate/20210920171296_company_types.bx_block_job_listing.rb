# This migration comes from bx_block_job_listing (originally 20210408070839)
class CompanyTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :company_types do |t|
      t.string :type_of_company
      t.timestamps
    end
  end
end
