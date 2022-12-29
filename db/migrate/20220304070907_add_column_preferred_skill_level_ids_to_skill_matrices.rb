class AddColumnPreferredSkillLevelIdsToSkillMatrices < ActiveRecord::Migration[6.0]
  def change
    add_column :skill_matrices, :preferred_skill_level_ids, :integer, array: true
  end
end
