# This migration comes from bx_block_job_listing (originally 20210427131430)
class CreateTableFollow < ActiveRecord::Migration[6.0]
  def change
    create_table :follows do |t|
      t.belongs_to :company_page
      t.belongs_to :profile
      t.timestamps
    end
  end
end
