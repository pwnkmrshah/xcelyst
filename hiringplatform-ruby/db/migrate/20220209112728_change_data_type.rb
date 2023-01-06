class ChangeDataType < ActiveRecord::Migration[6.0]
  def change
    change_column :profiles, :preferred_role_ids, :string, array: true
    change_column :profiles, :notice_period, :text
  end
end
