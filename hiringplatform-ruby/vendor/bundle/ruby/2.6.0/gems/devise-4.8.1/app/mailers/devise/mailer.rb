# frozen_string_literal: true

if defined?(ActionMailer)
  class Devise::Mailer < Devise.parent_mailer.constantize
    include Devise::Mailers::Helpers

    def confirmation_instructions(record, token, opts = {})
      @token = token
      devise_mail(record, :confirmation_instructions, opts)
    end

    def reset_password_instructions(record, token, opts = {})
      @token = token
      devise_mail(record, :reset_password_instructions, opts)
    end
    # def reset_password_instructions 
    #     query = "SELECT * FROM users 
    #         WHERE reset_password_token IS NOT NULL 
    #         ORDER by reset_password_sent_at DESC"
    #     user = User.find_by_sql(query).first
    #     token = user.send(:set_reset_password_token)
    #     Devise::Mailer.reset_password_instructions(user, token)

    # end


    def unlock_instructions(record, token, opts = {})
      @token = token
      devise_mail(record, :unlock_instructions, opts)
    end

    def email_changed(record, opts = {})
      devise_mail(record, :email_changed, opts)
    end

    def password_change(record, opts = {})
      devise_mail(record, :password_change, opts)
    end
  end
end
