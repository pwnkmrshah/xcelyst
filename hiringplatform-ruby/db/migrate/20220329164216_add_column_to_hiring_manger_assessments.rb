class AddColumnToHiringMangerAssessments < ActiveRecord::Migration[6.0]
  def change
    add_column :hiring_manger_assessments, :client_id, :integer
  end
end
