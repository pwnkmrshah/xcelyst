class AddDescriptionToEmailTemplate < ActiveRecord::Migration[6.0]
  def change
    add_column :email_templates, :description, :text
  end
end
