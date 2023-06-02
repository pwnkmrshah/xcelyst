# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

AdminUser.create(email: 'admin@xcelyst.com', password: 'password', password_confirmation: 'password') if AdminUser.find_by_email('admin@xcelyst.com').blank?
UserAdmin.create(email: 'admin@xcelyst.com', password: 'password', password_confirmation: 'password') if UserAdmin.find_by_email('admin@xcelyst.com').blank?
BxBlockAdminRolePermission::AdminRole.create(name: 'Super Admin') if BxBlockAdminRolePermission::AdminRole.find_by(name: 'Super Admin').blank?

AccountBlock::UserResume.all.each do |resume|
    resume.account.update(document_id: resume.document_id)
end

BxBlockDatabase::DownloadLimit.create(no_of_downloads: 5) unless BxBlockDatabase::DownloadLimit.first.present?

# AccountBlock::TemporaryAccount.all.each do |temp_acc|
#   if temp_acc.parsed_resume['Value']['ResumeData']['ResumeMetadata']['ReservedData'].present?
#       resp = temp_acc.parsed_resume['Value']['ResumeData']['ResumeMetadata']['ReservedData']
#       if resp['Names'].present?
#           temp_acc.update first_name: resp['Names'][0]
#       end
#   end
# end

schedule_interviews = BxBlockScheduling::ScheduleInterview.where(time_zone: nil)
schedule_interviews.update_all(time_zone: 'Asia/Kolkata')

# Create permissions for each module if they do not exist
def create_permission(module_name, permission_name)
  if module_name == 'rejected candidate'
    BxBlockAdminRolePermission::AdminPermission.find_or_create_by(module_name: 'rejected candidate', name: permission_name)
    BxBlockAdminRolePermission::AdminPermission.find_or_create_by(module_name: 'applied candidate', name: permission_name)
    BxBlockAdminRolePermission::AdminPermission.find_or_create_by(module_name: 'applied candidate', name: 'edit')
  else
    BxBlockAdminRolePermission::AdminPermission.find_or_create_by(module_name: module_name, name: permission_name)
  end
end

# Define the required permissions for each module
module_permissions = {
  "dashboard" => ["whatsapp", "client_dashboard"],
  "database user" => ["view", "upload_json_file", "delete"],
  "ai matching" => ["browse_ai_matching"],
  "candidate" => ["browse_candidate", "edit_candidate", "delete_candidate", "bulk_send_messages_to_account", "download"],
  "client" => ["browse_client", "add_client", "edit_client", "delete_client"],
  "test account" => ["browse_test_account"],
  "job description" => ["view"],
  "zoom meeting" => ["view", 'add'],
  "zoom user" => ["view", "sync_users"],
  "final feedback" => ["view"],
  "shortlist candidate" => ["browse_shortlist_candidate", "delete_shortlist_candidate"],
  "shortlisted candidate" => ["view", "delete"],
  "temporary account" => ["view", "permanent", "upload_bulk_resume", "bulk_send_messages", "temporary_by_admin", "delete", "import_bulk_resume"],
  "rejected candidate" => ["view"],
  "test score and course" => ["view", "edit"]
}

# Create permissions for each module if they do not exist
BxBlockAdminRolePermission::AdminPermission.transaction do
  ActiveRecord::Base.connection.reset_pk_sequence!('admin_permissions') if BxBlockAdminRolePermission::AdminPermission.count.zero?

  all_resources = ActiveAdmin.application.namespaces[:admin].resources
  all_modules = all_resources.map{|resource|resource.resource_name.human.downcase}
  default_permissions = ["view", "add", "edit", "delete"]

  all_modules.each do |module_name|
      next if ['admin user', 'Test dome', 'comment', 'user resume'].map(&:downcase).include? module_name
      module_name = 'rejected candidate' if module_name == 'applied job'
      module_name = 'role management' if module_name == 'admin role'
      module_name = 'contact request' if module_name == 'contact'
    permissions = module_permissions[module_name] || default_permissions
    permissions.each do |permission_name|
      create_permission(module_name, permission_name)
    end
  end  
end

# Create Super Admin Role and add this role to super admin
super_admin = UserAdmin.find_by(email: 'admin@xcelyst.com') 
super_admin_role = BxBlockAdminRolePermission::AdminRole.find_by(name: 'Super Admin') 
super_admin.create_admin_role_user(admin_role_id: super_admin_role.id) unless super_admin.admin_role_user.present?
all_permissions = BxBlockAdminRolePermission::AdminPermission.pluck(:id)
all_permissions.each do |id|
  super_admin_role.admin_role_permissions.create(admin_permission_id: id)
end
