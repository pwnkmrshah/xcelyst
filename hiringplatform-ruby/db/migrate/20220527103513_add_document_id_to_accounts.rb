class AddDocumentIdToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :document_id, :string
  end
end
