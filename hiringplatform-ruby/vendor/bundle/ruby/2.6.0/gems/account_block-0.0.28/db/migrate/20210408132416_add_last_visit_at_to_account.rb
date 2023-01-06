class AddLastVisitAtToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :last_visit_at, :datetime
  end
end
