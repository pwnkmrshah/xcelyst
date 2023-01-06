class CreateBxBlockManagerInterviewers < ActiveRecord::Migration[6.0]
  def change
    create_table :interviewers do |t|
      t.string :name
      t.string :email
      t.bigint :client_id, null: false
      t.timestamps
    end
  end
end
