class CreateBxBlockPrivacySettingsPrivacyPolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :privacy_policies do |t|
      t.text :description

      t.timestamps
    end
  end
end
