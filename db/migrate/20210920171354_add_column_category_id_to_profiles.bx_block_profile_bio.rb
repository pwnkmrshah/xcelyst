# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20210216115217)

class AddColumnCategoryIdToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :category_id, :integer
  end
end
