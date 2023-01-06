class CreateBxBlockShortlistingShortlistingCandidates < ActiveRecord::Migration[6.0]
  def change
    create_table :shortlisting_candidates do |t|
      t.bigint :client_id, null: false
      t.references :job_description, null: false, foreign_key: true
      t.bigint :candidate_id, null: false
      t.boolean :is_shortlisted

      t.timestamps
    end
    add_index :shortlisting_candidates, :client_id
    add_index :shortlisting_candidates, :candidate_id
  end
end
