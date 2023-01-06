class AddColumnToVideoInterviews < ActiveRecord::Migration[6.0]
  def change
    add_column :video_interviews, :client_id, :integer
    add_column :hr_assessments, :client_id, :integer
    
  end
end
