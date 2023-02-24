# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

AdminUser.create(email: 'admin@xcelyst.com', password: 'password', password_confirmation: 'password') if AdminUser.find_by_email('admin@xcelyst.com').blank?

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
  BxBlockAdminRolePermission::AdminPermission.find_or_create_by(module_name: module_name, name: permission_name)
end

# Define the required permissions for each module
module_permissions = {
  "rejected candidate" => ["browse"],
  "database user" => ["browse", "upload", "delete"],
  "ai macthing" => ["browse_ai_macthing"],
  "candidate" => ["browse_candidate", "edit_candidate", "delete_candidate", "send_message", "download"],
  "client" => ["browse_client", "new_client", "edit_client", "delete_client"],
  "test accounts" => ["browse_test_account"],
  "job description" => ["browse"],
  "shortlist candidate" => ["browse_shortlist_candidate", "delete_shortlist_candidate"],
  "temporary account" => ["browse", "permanent", "upload", "delete"]
}

# Create permissions for each module if they do not exist
BxBlockAdminRolePermission::AdminPermission.transaction do
  ActiveRecord::Base.connection.reset_pk_sequence!('admin_permissions') if BxBlockAdminRolePermission::AdminPermission.count.zero?

  all_resources = ActiveAdmin.application.namespaces[:admin].resources
  all_modules = all_resources.select { |resource| !resource.menu_item_options[:label].is_a?(Proc) }
                              .map { |resource| resource.menu_item_options[:label]&.downcase }

  default_permissions = ["browse", "add", "edit", "delete"]

  all_modules.each do |module_name|
      next if module_name.nil?
    permissions = module_permissions[module_name] || default_permissions
    permissions.each do |permission_name|
      create_permission(module_name, permission_name)
    end
  end  
end

