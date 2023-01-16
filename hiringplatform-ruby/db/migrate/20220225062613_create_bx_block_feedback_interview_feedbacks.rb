class CreateBxBlockFeedbackInterviewFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :interview_feedbacks do |t|
      t.references :feedback_parameter_lists, null: false, foreign_key: true
      t.float :rating
      t.text  :comments
      t.references :applied_jobs, null: false, foreign_key: true
      t.timestamps 
    end
  end
end
