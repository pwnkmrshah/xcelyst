class AdminUser < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    has_many :send_messages, -> { where(sender_type: "AdminUser") }, as: :sender, class_name: "BxBlockWhatsapp::WhatsappMessage", dependent: :destroy
    has_many :receive_messages, -> { where(receiver_type: "AdminUser") }, as: :receiver, class_name: "BxBlockWhatsapp::WhatsappMessage", dependent: :destroy
    has_many :whatsapp_chats, class_name: "BxBlockWhatsapp::WhatsappChat", foreign_key: :admin_user_id, dependent: :destroy

    has_one :admin_role_user, class_name: 'BxBlockAdminRolePermission::AdminRoleUser', dependent: :destroy
    has_one :admin_role, through: :admin_role_user, class_name: 'BxBlockAdminRolePermission::AdminRole'
    accepts_nested_attributes_for :admin_role_user, allow_destroy: true, reject_if: :all_blank

    devise :database_authenticatable,
           :rememberable, :validatable#, :recoverable
           
end
