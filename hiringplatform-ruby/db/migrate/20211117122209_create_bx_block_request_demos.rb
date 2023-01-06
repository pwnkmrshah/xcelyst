class CreateBxBlockRequestDemos < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_request_demos do |t|
      t.string :full_name
      t.string :phone_no
      t.string :email
      t.string :company_name
      t.text :contact_information

      t.timestamps
    end
  end
end
