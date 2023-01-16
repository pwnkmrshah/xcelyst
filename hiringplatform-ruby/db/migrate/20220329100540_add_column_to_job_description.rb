class AddColumnToJobDescription < ActiveRecord::Migration[6.0]
  def change
    add_column :job_descriptions, :degree, :string
    add_column :job_descriptions, :fieldOfStudy, :string
  end
end
