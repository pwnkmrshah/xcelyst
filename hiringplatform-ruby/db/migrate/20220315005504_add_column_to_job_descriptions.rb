class AddColumnToJobDescriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :job_descriptions, :parsed_jd, :jsonb
    add_column :job_descriptions, :jd_type, :string
    add_column :job_descriptions, :parsed_jd_transaction_id, :string
  end
end
