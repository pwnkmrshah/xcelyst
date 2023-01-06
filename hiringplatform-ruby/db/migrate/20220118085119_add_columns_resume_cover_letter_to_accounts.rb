class AddColumnsResumeCoverLetterToAccounts < ActiveRecord::Migration[6.0]
  def change
    remove_column :accounts, :resume
    add_column :accounts, :cover_letter_url, :string
    add_column :accounts, :resume_url, :string
  end
end
