class CreatePreferredRole < ActiveRecord::Migration[6.0]
  def change
    create_table :preferred_roles do |t|
      t.string :name
    end
  end
end
