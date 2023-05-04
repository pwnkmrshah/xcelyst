class AddCompanyUidToJobDatabase < ActiveRecord::Migration[6.0]
  def change
    add_column :job_databases, :company_uid, :string
  end
end
