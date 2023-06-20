module AccountBlock
  class SetPasswordMailer < ApplicationMailer
    def set_password_email
      fetch_email('set_password_email')
    end

    def reset_password
      fetch_email('reset_password')
    end
  end
end
