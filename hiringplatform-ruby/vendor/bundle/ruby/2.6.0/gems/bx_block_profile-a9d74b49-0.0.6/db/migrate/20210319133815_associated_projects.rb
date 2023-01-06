class AssociatedProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :associated_projects do |t|
      t.integer :project_id
      t.integer :associated_id
      t.timestamps
    end
  end
end
