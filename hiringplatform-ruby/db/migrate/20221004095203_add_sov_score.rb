class AddSovScore < ActiveRecord::Migration[6.0]
  def change
    add_column :shortlisting_candidates, :sovren_score, :integer
  end
end
