module Admin
 class UserMailer < ApplicationMailer

    def two_factor_authentication(admin_user)
      @admin_user = admin_user
      @admin_user.update!(otp: rand(1_00000..9_99999))
      mail(to: @admin_user.email, subject: 'Your OTP code for two-factor authentication')
    end
  end
end