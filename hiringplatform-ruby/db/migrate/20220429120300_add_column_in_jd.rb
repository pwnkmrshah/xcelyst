class AddColumnInJd < ActiveRecord::Migration[6.0]
  def change
    add_column :job_descriptions, :sovren_ui_url, :string
  end
end
