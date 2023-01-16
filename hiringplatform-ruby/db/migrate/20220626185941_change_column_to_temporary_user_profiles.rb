class ChangeColumnToTemporaryUserProfiles < ActiveRecord::Migration[6.0]
  def change
    remove_column :temporary_user_profiles, :work_experience
    remove_column :temporary_user_profiles, :languages
    remove_column :temporary_user_profiles, :education
    remove_column :temporary_user_profiles, :organizations

    add_column :temporary_user_profiles, :work_experience, :jsonb
    add_column :temporary_user_profiles, :languages, :jsonb
    add_column :temporary_user_profiles, :education, :jsonb
    add_column :temporary_user_profiles, :organizations, :jsonb

  end
end
