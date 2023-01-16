# This migration comes from bx_block_job_listing (originally 20210503115503)
class ChangeColumnSkillIdIntoArray < ActiveRecord::Migration[6.0]
  def change
    change_column :jobs, :skill_id, :integer, array: true, default: [], using: 'ARRAY[skill_id]::INTEGER[]'
  end
end
