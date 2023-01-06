class CreateBxBlockWhatsappWhatsappMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :whatsapp_messages do |t|
      t.references :whatsapp_chat, null: false
      t.text :message
      t.references :sender, polymorphic: true,  null: false
      t.references :receiver, polymorphic: true, null: false
      t.timestamps
    end
  end
end
