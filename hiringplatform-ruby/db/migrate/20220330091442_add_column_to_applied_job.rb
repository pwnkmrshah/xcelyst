class AddColumnToAppliedJob < ActiveRecord::Migration[6.0]
  def change
    add_column :applied_jobs, :shortlisting_candidate_id, :bigint
  end
end
