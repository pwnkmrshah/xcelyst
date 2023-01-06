# This migration comes from bx_block_job_listing (originally 20210803063624)
class AddColumnsInJobsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :other_skills, :string, array: true, default: []
    add_column :jobs, :salary, :decimal, default: 0.00
  end
end
