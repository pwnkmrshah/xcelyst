module AccountBlock
  class SetPasswordMailer < ApplicationMailer
    def set_password_email
      fetch_email(@record.email)
    end

    def reset_password
      fetch_email(@record.email)
    end

    def client_changed_password
      fetch_email(@record.email)
    end

  end
end
