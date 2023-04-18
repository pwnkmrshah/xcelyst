class AddIdentifierToRole < ActiveRecord::Migration[6.0]
  def change
    add_column :roles, :identifier, :string
  end
end
