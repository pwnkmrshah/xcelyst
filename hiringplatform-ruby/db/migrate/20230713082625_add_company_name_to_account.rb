class AddCompanyNameToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :company_name, :string
  end
end
