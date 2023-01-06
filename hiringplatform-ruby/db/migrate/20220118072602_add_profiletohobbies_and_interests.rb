class AddProfiletohobbiesAndInterests < ActiveRecord::Migration[6.0]
  def change
    add_column :industries, :profile_id, :integer
    add_column :system_experiences, :profile_id, :integer
  end
end