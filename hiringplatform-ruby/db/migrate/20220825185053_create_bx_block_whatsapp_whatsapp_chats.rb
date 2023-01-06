class CreateBxBlockWhatsappWhatsappChats < ActiveRecord::Migration[6.0]
  def change
    create_table :whatsapp_chats do |t|
      t.references :admin_user, null: false
      t.references :user, polymorphic: true, null: false
      t.timestamps
    end
  end
end
