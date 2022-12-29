# This migration comes from bx_block_job_listing (originally 20210413135913)
class CreateQuestionAnswer < ActiveRecord::Migration[6.0]
  def change
    create_table :question_answers do |t|
      t.string :question
      t.string :answer
      t.timestamps
    end
  end
end