class AddDocumentIdToJd < ActiveRecord::Migration[6.0]
  def change
    add_column :job_descriptions, :document_id, :string
  end
end
