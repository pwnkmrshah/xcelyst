class AddProfiletoassociatedProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :associated_projects, :profile_id, :integer
  end
end