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
   
    def can_read_account_block_for_candidate?(user)
        user.admin_role.present? && user.admin_role.admin_permissions.exists?(name: 'browse_candidate') && (user.admin_role.admin_permissions.exists?(name: 'browse_candidate') || user.admin_role.admin_permissions.exists?(name: 'new_candidate') || user.admin_role.admin_permissions.exists?(name: 'edit_candidate') || user.admin_role.admin_permissions.exists?(name: 'delete_candidate'))
    end

    def can_read_account_block_for_client?(user)
        user.admin_role.present? && user.admin_role.admin_permissions.exists?(name: 'browse_client') && (user.admin_role.admin_permissions.exists?(name: 'browse_client') || user.admin_role.admin_permissions.exists?(name: 'new_client') || user.admin_role.admin_permissions.exists?(name: 'edit_client') || user.admin_role.admin_permissions.exists?(name: 'delete_client'))
    end

    def can_read_account_block_for_ai_matching?(user)
        user.admin_role.present? && user.admin_role.admin_permissions.exists?(name: 'browse_ai_macthing') && (user.admin_role.admin_permissions.exists?(name: 'browse_ai_macthing') || user.admin_role.admin_permissions.exists?(name: 'new_ai_macthing') || user.admin_role.admin_permissions.exists?(name: 'edit_ai_macthing') || user.admin_role.admin_permissions.exists?(name: 'delete_ai_macthing'))
    end

    def can_read_account_block_for_shortlist_candidate?(user)
        user.admin_role.present? && user.admin_role.admin_permissions.exists?(name: 'browse_shortlist_candidate') && (user.admin_role.admin_permissions.exists?(name: 'browse_shortlist_candidate') || user.admin_role.admin_permissions.exists?(name: 'new_shortlist_candidate') || user.admin_role.admin_permissions.exists?(name: 'edit_shortlist_candidate') || user.admin_role.admin_permissions.exists?(name: 'delete_shortlist_candidate'))
    end


    def can_read_account_block_for_test_account?(user)
        user.admin_role.present? && user.admin_role.admin_permissions.exists?(name: 'browse_test_account') && (user.admin_role.admin_permissions.exists?(name: 'browse_test_account') || user.admin_role.admin_permissions.exists?(name: 'new_test_account') || user.admin_role.admin_permissions.exists?(name: 'edit_test_account') || user.admin_role.admin_permissions.exists?(name: 'delete_test_account'))
    end

end
