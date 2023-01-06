class RenameAppliedJobIdToRoleId < ActiveRecord::Migration[6.0]
  def change
    rename_column :applied_jobs, :job_id, :role_id
  end
end
