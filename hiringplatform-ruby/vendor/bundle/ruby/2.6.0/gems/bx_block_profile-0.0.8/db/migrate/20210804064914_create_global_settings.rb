class CreateGlobalSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :global_settings do |t|
      t.string :notice_period
      t.timestamps
    end
  end
end
