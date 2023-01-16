class AddCityColumnInProfilesTable < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :city, :string
  end
end
