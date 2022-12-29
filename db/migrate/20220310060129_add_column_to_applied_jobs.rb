class AddColumnToAppliedJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :applied_jobs, :accepted, :boolean
  end
end
