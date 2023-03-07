module BxBlockAdminRolePermission
	class AdminRoleUser < ApplicationRecord 
	    self.table_name = :admin_role_users

	    belongs_to :admin_role, foreign_key: 'admin_role_id', class_name: 'BxBlockAdminRolePermission::AdminRole'
	    belongs_to :admin_user, foreign_key: 'admin_user_id', class_name: 'AdminUser', optional: true
	    belongs_to :user_admin, foreign_key: 'user_admin_id', class_name: 'UserAdmin'

	end
end
