class AddCompanynamelogoToJobDatabase < ActiveRecord::Migration[6.0]
  def change
    add_column :job_databases, :company_name, :string
    add_column :job_databases, :company_logo, :string
  end
end
