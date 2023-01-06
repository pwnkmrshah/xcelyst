class AddColumnOnJobDescription < ActiveRecord::Migration[6.0]
  def change
  	add_column :job_descriptions, :others_skills, :string, array: true, default: []
  	change_column :roles, :managers, :text
  end
end
