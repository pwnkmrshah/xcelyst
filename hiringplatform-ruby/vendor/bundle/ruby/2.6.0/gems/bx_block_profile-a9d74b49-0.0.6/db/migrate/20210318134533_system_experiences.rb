class SystemExperiences < ActiveRecord::Migration[6.0]
  def change
    create_table :system_experiences do |t|
      t.string :system_experience
      t.timestamps
    end
  end
end
