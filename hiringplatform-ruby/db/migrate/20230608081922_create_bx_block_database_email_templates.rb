class CreateBxBlockDatabaseEmailTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :email_templates do |t|
      t.string :template_name
      t.string :label
      t.string :from
      t.string :to
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
