# This migration comes from bx_block_privacy_settings (originally 20210301173042)
class CreateBxBlockPrivacySettingsPrivacyPolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :privacy_policies do |t|
      t.text :description

      t.timestamps
    end
  end
end
