class CreateBxBlockJobJobDatabases < ActiveRecord::Migration[6.0]
  def change
    create_table :job_databases do |t|
      t.string :url
      t.string :job_uid
      t.string :job_title
      t.string :location
      t.datetime :date_published
      t.string :business_area
      t.string :area_domain
      t.string :reference_code
      t.string :employment
      t.text :responsibilities, array: true, default: []
      t.text :skills, array: true, default: []
      t.string :apply_for_job_url
      t.text :description, array: true, default: []

      t.timestamps
    end
  end
end
