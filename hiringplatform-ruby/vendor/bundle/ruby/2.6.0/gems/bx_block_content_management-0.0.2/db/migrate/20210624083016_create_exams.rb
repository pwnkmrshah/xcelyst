class CreateExams < ActiveRecord::Migration[6.0]
  def change
    create_table :exams do |t|
      t.string :heading
      t.text :description, size: :long
      t.date :to
      t.date :from
      t.timestamps
    end
  end
end
