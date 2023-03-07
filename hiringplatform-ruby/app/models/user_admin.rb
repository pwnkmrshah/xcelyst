class UserAdmin < ApplicationRecord
  has_many :send_messages,
    -> { where(sender_type: 'UserAdmin') },
    as: :sender,
    class_name: 'BxBlockWhatsapp::WhatsappMessage',
    dependent: :destroy
  has_many :receive_messages,
    -> { where(receiver_type: 'UserAdmin') },
    as: :receiver,
    class_name: 'BxBlockWhatsapp::WhatsappMessage',
    dependent: :destroy
  has_many :whatsapp_chats,
    class_name: 'BxBlockWhatsapp::WhatsappChat',
    foreign_key: :admin_user_id,
    dependent: :destroy

  has_one :admin_role_user,
    class_name: 'BxBlockAdminRolePermission::AdminRoleUser',
    dependent: :destroy
  has_one :admin_role,
    through: :admin_role_user,
    class_name: 'BxBlockAdminRolePermission::AdminRole'
  accepts_nested_attributes_for :admin_role_user,
    allow_destroy: true,
    reject_if: :all_blank

  devise :database_authenticatable,
         :rememberable,
         :validatable

  def can_read_account_block_for?(user, account_block)
    user.admin_role.present? &&
      user.admin_role.admin_permissions.exists?(name: "browse_#{account_block}") &&
      (
        user.admin_role.admin_permissions.exists?(name: "browse_#{account_block}") ||
          user.admin_role.admin_permissions.exists?(name: "new_#{account_block}") ||
          user.admin_role.admin_permissions.exists?(name: "edit_#{account_block}") ||
          user.admin_role.admin_permissions.exists?(name: "delete_#{account_block}")
      )
  end

  def can_read_account_block_for_candidate?(user)
    can_read_account_block_for?(user, 'candidate')
  end

  def can_read_account_block_for_client?(user)
    can_read_account_block_for?(user, 'client')
  end

  def can_read_account_block_for_ai_matching?(user)
    can_read_account_block_for?(user, 'ai_matching')
  end

  def can_read_account_block_for_shortlist_candidate?(user)
    can_read_account_block_for?(user, 'shortlist_candidate')
  end

  def can_read_account_block_for_test_account?(user)
    can_read_account_block_for?(user, 'test_account')
  end


end
