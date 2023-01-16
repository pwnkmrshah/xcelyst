class CreateBxBlockContactUsContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.references :account
      t.string :name
      t.string :email
      t.string :phone_number
      t.text :description
      t.timestamps
    end
  end
end
