namespace :admin_setup do
  desc "Create super admin and send credentials"
  task create_super_admin: :environment do
    SUPER_ADMIN = [
      'admin@xcelyst.com',
      'ashutosh.gupta@xcelyst.com',
      'ritesh.agarwal@xcelyst.com',
      'vishwa.bhushan@xcelyst.com',
      'tarun.lala@xcelyst.com',
      'namita.akhauri@xcelyst.com'
    ]

    SUPER_ADMIN.each do |email|
      password = generate_password
      super_admin = UserAdmin.find_or_initialize_by(email: email)

      unless super_admin.persisted?
        super_admin.password = password
        super_admin.password_confirmation = password
        super_admin.enable_2FA = true
        super_admin.save!
      end

      set_super_admin_role(super_admin)
      Admin::UserMailer.send_creds(super_admin, password).deliver_now
    end
  end

  def generate_password(length = 12)
    symbols = %w(! @ # $ % ^ &)
    numbers = ('0'..'9').to_a
    lowercase_letters = ('a'..'z').to_a
    uppercase_letters = ('A'..'Z').to_a

    characters = symbols + numbers + lowercase_letters + uppercase_letters

    Array.new(length) { characters.sample }.join
  end

  def set_super_admin_role(admin)
    return if admin.nil?

    super_admin_role = BxBlockAdminRolePermission::AdminRole.find_by(name: 'Super Admin')

    unless admin.admin_role_user.present?
      admin.create_admin_role_user(admin_role_id: super_admin_role.id)
    end

    all_permissions = BxBlockAdminRolePermission::AdminPermission.pluck(:id)

    all_permissions.each do |id|
      super_admin_role.admin_role_permissions.create(admin_permission_id: id)
    end
  end
end
