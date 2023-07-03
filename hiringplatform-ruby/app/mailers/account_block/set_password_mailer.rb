module AccountBlock
  class SetPasswordMailer < ApplicationMailer
    def set_password_email
      fetch_email('set_password_email', @record.email)
    end

    def reset_password
      fetch_email('reset_password', @record.email)
    end

    def client_changed_password
      fetch_email('client_changed_password', @record.email)
    end

  end
end
