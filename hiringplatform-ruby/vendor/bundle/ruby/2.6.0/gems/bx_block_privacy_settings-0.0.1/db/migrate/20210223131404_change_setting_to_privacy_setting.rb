class ChangeSettingToPrivacySetting < ActiveRecord::Migration[6.0]
  def change
  	rename_table :settings, :privacy_settings
  end
end
