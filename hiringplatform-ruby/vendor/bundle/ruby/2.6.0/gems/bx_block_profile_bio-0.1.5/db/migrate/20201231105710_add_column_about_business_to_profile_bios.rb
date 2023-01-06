# frozen_string_literal: true

class AddColumnAboutBusinessToProfileBios < ActiveRecord::Migration[6.0]
  def change
    add_column :profile_bios, :about_business, :text
  end
end
