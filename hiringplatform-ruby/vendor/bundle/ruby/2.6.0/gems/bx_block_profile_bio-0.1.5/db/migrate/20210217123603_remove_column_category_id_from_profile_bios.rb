# frozen_string_literal: true

class RemoveColumnCategoryIdFromProfileBios < ActiveRecord::Migration[6.0]
  def change
    remove_column :profile_bios, :category_id
  end
end
