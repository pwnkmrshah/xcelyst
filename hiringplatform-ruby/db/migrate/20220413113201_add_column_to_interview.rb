class AddColumnToInterview < ActiveRecord::Migration[6.0]
  def change
    add_column :schedule_interviews, :feedback, :string
  end
end
