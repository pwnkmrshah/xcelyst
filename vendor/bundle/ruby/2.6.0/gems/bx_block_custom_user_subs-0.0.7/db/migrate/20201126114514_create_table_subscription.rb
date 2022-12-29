class CreateTableSubscription < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_custom_user_subs_subscriptions do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.date :valid_up_to
    end
  end
end
