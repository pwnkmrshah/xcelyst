class CreateEmailOtps < ActiveRecord::Migration[6.0]
  def change
    create_table :email_otps do |t|
      t.string :email
      t.integer :pin
      t.boolean :activated, :null => false, :default => false
      t.timestamp :valid_until
      t.timestamps
    end
  end
end
