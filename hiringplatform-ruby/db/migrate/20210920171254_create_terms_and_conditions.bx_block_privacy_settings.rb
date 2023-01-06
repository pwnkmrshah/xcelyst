# This migration comes from bx_block_privacy_settings (originally 20210303060459)
class CreateTermsAndConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :terms_and_conditions do |t|
      t.text :description

      t.timestamps
    end
  end
end
