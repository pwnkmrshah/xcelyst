class AddCurrencyToJobDesctiption < ActiveRecord::Migration[6.0]
  def change
    add_column :job_descriptions, :currency, :string
  end
end
