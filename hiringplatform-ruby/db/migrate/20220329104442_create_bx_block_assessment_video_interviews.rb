class CreateBxBlockAssessmentVideoInterviews < ActiveRecord::Migration[6.0]
  def change
    create_table :video_interviews do |t|
      t.string :interviewer_name
      t.string :feedback
      t.references :account, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.timestamps
    end
  end
end
