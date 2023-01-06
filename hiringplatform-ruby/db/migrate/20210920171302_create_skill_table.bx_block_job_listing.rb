# This migration comes from bx_block_job_listing (originally 20210413132447)
class CreateSkillTable < ActiveRecord::Migration[6.0]
  def change
    create_table :skills do |t|
      t.string :skill_name
      t.timestamps
    end
  end
end
