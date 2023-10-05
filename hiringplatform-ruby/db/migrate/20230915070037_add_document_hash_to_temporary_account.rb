class AddDocumentHashToTemporaryAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :temporary_accounts, :document_hash, :string
  end
end
