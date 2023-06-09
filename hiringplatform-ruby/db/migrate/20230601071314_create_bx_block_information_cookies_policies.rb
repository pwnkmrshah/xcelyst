class CreateBxBlockInformationCookiesPolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :cookies_policies do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
