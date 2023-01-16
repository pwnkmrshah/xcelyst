class CreateJobDescritption < ActiveRecord::Migration[6.0]
  def change
    create_table :job_descriptions do |t|
      t.string :job_title
      t.string :role_title
      t.references :preferred_overall_experience, null: false, foreign_key: true
      t.string :minimum_salary
      t.string :location
      t.text :company_description
      t.text :job_responsibility
      t.references :role, null: false, foreign_key: true
    end
  end
end
