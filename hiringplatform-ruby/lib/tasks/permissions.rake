namespace :permissions do
  desc 'Create permissions'
  task :create, [:module_name, :custom_permissions] => :environment do |t, args|
    # AdhocService.run(args[:filename], branch: args[:branch].presence || "main")
    if args[:module_name]
      allowed_permissions = if args[:custom_permissions].present?
                              args[:custom_permissions].split ' '
                            else
                              ["browse", "add", "edit", "delete"]
                            end
      allowed_permissions.each do |permission_name|
        BxBlockAdminRolePermission::AdminPermission.find_or_create_by(module_name: args[:module_name], name: permission_name)
      end
    end
  end
end
