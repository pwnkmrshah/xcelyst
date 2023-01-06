class CreateAccountBlockTemporaryAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :temporary_accounts do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.jsonb :parsed_resume
      t.string :document_id

      t.timestamps
    end
  end
end
