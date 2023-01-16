class CreateFeedbackParameterList < ActiveRecord::Migration[6.0]
  def change
    create_table :feedback_parameter_lists do |t|
      t.string :name
    end
  end
end
