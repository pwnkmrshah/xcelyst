# frozen_string_literal: true

class AddColumnAccountIdToViewProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :view_profiles, :account_id, :integer
  end
end
