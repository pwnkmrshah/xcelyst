class AddProfileRoleColumnInProfilesTable < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :profile_role, :integer
  end
end
