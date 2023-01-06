# This migration comes from bx_block_job_listing (originally 20210413123627)
class CreateJob < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.string :job_title
      t.boolean :remote_job , default: true
      t.string :location
      t.integer :employment_type_id
      t.integer :total_inteview_rounds
      t.integer :skill_id
      t.integer :question_answer_id
      t.text :job_description
      t.timestamps
    end
  end
end
