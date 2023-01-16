# frozen_string_literal: true

class AddColumnCategoryIdToProfileBios < ActiveRecord::Migration[6.0]
  def change
    add_column :profile_bios, :category_id, :integer
  end
end
