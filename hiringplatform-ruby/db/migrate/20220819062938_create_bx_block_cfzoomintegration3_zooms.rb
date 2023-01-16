class CreateBxBlockCfzoomintegration3Zooms < ActiveRecord::Migration[6.0]
  def change
    create_table :zooms do |t|
      t.string :zoom_user_id
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :status

      t.timestamps
    end
  end
end
