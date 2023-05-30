class AddCurrencyToProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :currency, :string
  end
end
