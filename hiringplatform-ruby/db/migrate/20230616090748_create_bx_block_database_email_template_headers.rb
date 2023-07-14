class CreateBxBlockDatabaseEmailTemplateHeaders < ActiveRecord::Migration[6.0]
  def change
    create_table :email_template_headers do |t|
      t.text :body
      t.boolean :enable

      t.timestamps
    end
  end
end
