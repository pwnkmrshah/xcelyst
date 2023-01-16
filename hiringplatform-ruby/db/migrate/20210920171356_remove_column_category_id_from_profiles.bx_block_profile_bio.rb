# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20210217123603)

class RemoveColumnCategoryIdFromProfiles < ActiveRecord::Migration[6.0]
  def change
    remove_column :profiles, :category_id
  end
end
