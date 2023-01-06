# This migration comes from bx_block_job_listing (originally 20210426093054)
class AppliedJobTable < ActiveRecord::Migration[6.0]
  def change
    create_table :applied_jobs do |t|
      t.integer :profile_id
      t.integer :job_id
      t.integer :company_page_id
      t.string :apllied_job_title
      t.timestamps
    end
  end
end
