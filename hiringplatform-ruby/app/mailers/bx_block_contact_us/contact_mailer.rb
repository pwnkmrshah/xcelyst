module BxBlockContactUs
  class ContactMailer < ApplicationMailer
    def admin_email(contact)
      @contact = contact
      @admin_email = "info@xcelyst.com"

      mail(to: @admin_email, subject: 'Request for User Connection and Demo.') do |format|
        format.html { render 'admin_email' }
      end
    end

    def user_email(contact)
      @contact = contact
      @to_email = @contact.email

      mail(to: @to_email, subject: 'Thank you for contacting Xcelyst!.') do |format|
        format.html { render 'user_email' }
      end
    end
  end
end
