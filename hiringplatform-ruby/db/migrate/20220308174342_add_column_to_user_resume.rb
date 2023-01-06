class AddColumnToUserResume < ActiveRecord::Migration[6.0]
  def change
    add_column :user_resumes, :index_id, :string
    add_column :user_resumes, :document_id, :string
    add_column :user_resumes, :sovren_score, :integer
  end
end
