class CreateAccountBlockUserResumes < ActiveRecord::Migration[6.0]
  def change
    create_table :user_resumes do |t|
      t.string :resume_id, null: false
      t.references :account, null: false, foreign_key: true
      t.text :resume_file
      t.jsonb :parsed_resume
      t.string :transaction_id

      t.timestamps
    end
    add_index :user_resumes, :resume_id
  end
end
