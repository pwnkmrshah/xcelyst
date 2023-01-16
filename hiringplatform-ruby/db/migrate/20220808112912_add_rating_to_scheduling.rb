class AddRatingToScheduling < ActiveRecord::Migration[6.0]
  def change
    add_column :schedule_interviews, :rating, :float
  end
end
