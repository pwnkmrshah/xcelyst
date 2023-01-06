module BxBlockWhatsapp
    class WhatsappMessage < ApplicationRecord
        self.table_name = :whatsapp_messages

        belongs_to :whatsapp_chat
        belongs_to :sender, :polymorphic => true,  foreign_key: 'sender_id'
        belongs_to :receiver, :polymorphic => true,  foreign_key: 'receiver_id'

        scope :by_most_recent, -> { order(:created_at).reverse_order }

    end
end
