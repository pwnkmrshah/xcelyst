class CreateVanMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :van_members do |t|
      t.integer :account_id
      t.integer :van_id
    end
  end
end
