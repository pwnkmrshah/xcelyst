module BxBlockWhatsapp
  class WhatsappChat < ApplicationRecord
    scope :by_most_recent_message, -> {
      joins(:whatsapp_messages).merge(WhatsappMessage.by_most_recent)
    }

    self.table_name = :whatsapp_chats

    belongs_to :admin_user, foreign_key: :admin_user_id
    belongs_to :user, polymorphic: true

    has_many :whatsapp_messages, dependent: :destroy
    
  end
end
