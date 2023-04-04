class AddHonorAwardsAndLinkedinToTemporaryUserProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :temporary_user_profiles, :honor_awards, :jsonb, array: true, default: []
    add_column :temporary_user_profiles, :linkedin_url, :string
  end
end
