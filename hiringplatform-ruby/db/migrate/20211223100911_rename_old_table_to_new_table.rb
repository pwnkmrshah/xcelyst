class RenameOldTableToNewTable < ActiveRecord::Migration[6.0]
  def change
    rename_table :bx_block_request_demos, :request_demos
  end
end
