class CreatejobSuggestion < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs_suggestions do |t|
      t.string :suggestion
   end
  end
end