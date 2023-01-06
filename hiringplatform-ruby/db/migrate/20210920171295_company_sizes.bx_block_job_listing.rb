# This migration comes from bx_block_job_listing (originally 20210408070249)
class CompanySizes < ActiveRecord::Migration[6.0]
  def change
    create_table :company_sizes do |t|
      t.string :size_of_company
      t.timestamps
    end
  end
end
