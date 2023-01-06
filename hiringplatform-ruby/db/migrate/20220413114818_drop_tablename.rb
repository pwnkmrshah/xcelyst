class DropTablename < ActiveRecord::Migration[6.0]
  def change
    drop_table :hiring_manger_assessments
    drop_table :hr_assessments
    drop_table :video_interviews
  end
end
