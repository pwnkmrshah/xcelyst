module BxBlockContactUs
  class ContactMailer < ApplicationMailer
    def admin_email
      fetch_email('admin_email')
    end

    def user_email
      fetch_email('user_email', @record.email)
    end
  end
end
