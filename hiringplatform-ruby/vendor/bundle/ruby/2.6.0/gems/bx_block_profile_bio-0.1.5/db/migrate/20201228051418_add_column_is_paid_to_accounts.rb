# frozen_string_literal: true

class AddColumnIsPaidToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :is_paid, :boolean, default: false
  end
end
