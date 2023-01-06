class CreateFeedbackInterview < ActiveRecord::Migration[6.0]
  def change
    create_table :feedback_interviews do |t|
      t.string :name
    end
  end
end
