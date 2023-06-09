module Admin
 class UserMailer < ApplicationMailer

    def two_factor_authentication(admin_user)
      @admin_user = admin_user
      @admin_user.update!(otp: rand(1_00000..9_99999))
      mail(to: @admin_user.email, subject: 'Two-Factor Authentication OTP for Your Xcelyst Account')
    end

    def send_creds(admin , password)
      subject = 'Congratulations! You have been assigned the SuperAdmin Role for Xcelyst.ai'
      @admin = admin
      @password = password
      mail(to: @admin.email, subject: subject)
    end
  end
end