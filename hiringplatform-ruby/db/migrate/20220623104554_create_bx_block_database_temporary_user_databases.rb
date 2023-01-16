class CreateBxBlockDatabaseTemporaryUserDatabases < ActiveRecord::Migration[6.0]
  def change
    create_table :temporary_user_databases do |t|
      t.string :full_name
      t.string :title
      t.string :zipcode
      t.string :city
      t.string :status
      t.boolean :ready_to_move
      t.string :name
      t.string :location, array: true, default: []
      t.string :experience
      t.string :company
      t.string :position, array: true, default: []
      t.string :previous_work, array: true, default: []
      t.string :skills, array: true, default: []
      t.string :degree
      t.string :job_projects
      t.string :lead_lists

      t.timestamps
    end
  end
end
