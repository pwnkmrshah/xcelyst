class AddColumnToMembersBios < ActiveRecord::Migration[6.0]
  def change
    add_column :members_bios, :order, :integer
  end
end
