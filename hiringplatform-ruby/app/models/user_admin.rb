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

  def role
    admin_role&.name&.downcase    
  end

  def is_admin?
    admin_role&.name&.downcase == 'super admin'
  end

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

  def permission_for_whatsapp?(user)
    user.admin_role.present? &&
      user.admin_role.admin_permissions.exists?(name: "whatsapp")   
  end

  def can_edit_admin_user?(user)
    user.admin_role.present? &&
      user.admin_role.admin_permissions.exists?(name: 'edit', module_name:'user admin')
  end

  def can_delete_admin_user?(user)
    user.admin_role.present? &&
      user.admin_role.admin_permissions.exists?(name: 'delete', module_name:'user admin')
  end

  def can_edit_role?(user)
    user.admin_role.present? &&
      user.admin_role.admin_permissions.exists?(name: 'edit', module_name:'role management')
  end

  def can_delete_role?(user)
    user.admin_role.present? &&
      user.admin_role.admin_permissions.exists?(name: 'delete', module_name:'role management')
  end

  def permission_for_client_dashboard?(user)
    user.admin_role.present? &&
      user.admin_role.admin_permissions.exists?(name: "client_dashboard")
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

  def upload_json_file?(user)
    user.admin_role.present? &&
      user.admin_role.admin_permissions.exists?(name: "upload_json_file")
  end

  def upload_resume_file?(user)
    user.admin_role.present? &&
      user.admin_role.admin_permissions.exists?(name: "upload_bulk_resume")
  end

  def permission_for_permanent?(user)
    user.admin_role.present? &&
      user.admin_role.admin_permissions.exists?(name: "permanent")
  end

  def permission_for_make_permanent_account?(user)
    user.admin_role.present? &&
      user.admin_role.admin_permissions.exists?(name: "temporary_by_admin")
  end

  def permission_for_delete?(user)
    user.admin_role.present? &&
       user.admin_role.admin_permissions.exists?(name: 'delete', module_name:'temporary account')
  end

  def permission_for_candidate_send_message?(user)
    user.admin_role.present? &&
       user.admin_role.admin_permissions.exists?(name: 'bulk_send_messages_to_account', module_name:'candidate')
  end

  def permission_for_candidate_download_file?(user)
    user.admin_role.present? &&
       user.admin_role.admin_permissions.exists?(name: 'download', module_name:'candidate')
  end

  def permission_for_temporary_account_send_message?(user)
    user.admin_role.present? &&
       user.admin_role.admin_permissions.exists?(name: 'bulk_send_messages', module_name:'temporary account')
  end

  def can_edit_applied_candidate?(user)
    user.admin_role.present? &&
       user.admin_role.admin_permissions.exists?(name: 'edit', module_name:'applied candidate')
  end

  def can_view_applied_candidate?(user)
    user.admin_role.present? &&
       user.admin_role.admin_permissions.exists?(name: 'view', module_name:'applied candidate')
  end

  def can_view_rejected_candidate?(user)
    user.admin_role.present? &&
       user.admin_role.admin_permissions.exists?(name: 'view', module_name:'rejected candidate')
  end

  def can_sync_zoom_user?(user)
    user.admin_role.present? &&
       user.admin_role.admin_permissions.exists?(name: 'sync_users', module_name:'zoom user')
  end
  
  def can_edit_test_score?(user)
    user.admin_role.present? &&
       user.admin_role.admin_permissions.exists?(name: 'edit', module_name:'test score and course')
  end

  def can_view_test_score?(user)
    user.admin_role.present? &&
       user.admin_role.admin_permissions.exists?(name: 'view', module_name:'test score and course')
  end
end
