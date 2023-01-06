class CreateCourse < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :course_name
      t.string :duration
      t.string :year
      t.integer :profile_id
      t.timestamps
    end
  end
end
