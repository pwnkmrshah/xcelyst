# frozen_string_literal: true

class AddColumnToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :gender, :integer
    add_column :accounts, :date_of_birth, :date
    add_column :accounts, :age, :integer
  end
end
