# This migration comes from bx_block_privacy_settings (originally 20210223131404)
class ChangeSettingToPrivacySetting < ActiveRecord::Migration[6.0]
  def change
  	rename_table :settings, :privacy_settings
  end
end
