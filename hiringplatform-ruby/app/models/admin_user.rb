class AdminUser < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    has_many :send_messages, -> { where(sender_type: "AdminUser") }, as: :sender, class_name: "BxBlockWhatsapp::WhatsappMessage", dependent: :destroy
    has_many :receive_messages, -> { where(receiver_type: "AdminUser") }, as: :receiver, class_name: "BxBlockWhatsapp::WhatsappMessage", dependent: :destroy
    has_many :whatsapp_chats, class_name: "BxBlockWhatsapp::WhatsappChat", foreign_key: :admin_user_id, dependent: :destroy

    devise :database_authenticatable,
           :rememberable, :validatable#, :recoverable
           
end
