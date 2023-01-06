class CreateSkillMatrix < ActiveRecord::Migration[6.0]
  def change
    create_table :skill_matrices do |t|
      t.belongs_to :job_description
      t.belongs_to :domain_sub_category
      t.integer :preferred_overall_experience_ids, array: true, default: []
    end
  end
end
