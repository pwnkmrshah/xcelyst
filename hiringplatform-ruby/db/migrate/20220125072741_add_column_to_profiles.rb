class AddColumnToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :current_compensation, :string
    add_column :profiles, :expected_compensation, :string
    add_column :profiles, :notice_period, :string
    add_column :profiles, :preferred_role_ids, :integer, array: true, default: []
    add_column :profiles, :location_preference, :string,  array: true, default: []
  end
end
