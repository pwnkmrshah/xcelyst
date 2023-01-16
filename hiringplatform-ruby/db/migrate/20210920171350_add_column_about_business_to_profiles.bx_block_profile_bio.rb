# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20201231105710)

class AddColumnAboutBusinessToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :about_business, :text
  end
end
