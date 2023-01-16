class AddColumnsToShortlistingCandidates < ActiveRecord::Migration[6.0]
  def change
    add_column :shortlisting_candidates, :shortlisted_by_admin, :integer
    add_column :shortlisting_candidates, :is_applied_by_candidate, :boolean
  end
end
