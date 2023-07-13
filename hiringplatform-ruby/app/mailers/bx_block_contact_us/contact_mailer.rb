module BxBlockContactUs
  class ContactMailer < ApplicationMailer
    def admin_email
      fetch_email()
    end

    def user_email
      fetch_email(@record.email)
    end
  end
end
