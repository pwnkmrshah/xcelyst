class AddFinalScoreColumnToAppliedJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :applied_jobs, :final_score, :float
    add_column :applied_jobs, :final_feedback, :string
  end
end
