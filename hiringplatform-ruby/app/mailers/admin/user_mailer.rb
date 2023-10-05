module Admin
 class UserMailer < ApplicationMailer
    include EmailHelper

    def two_factor_authentication(admin_user)
      admin_user.update!(otp: rand(1_00000..9_99999))
      email_template =find_email_template_by_label(action_name)
      return unless email_template
      body = email_template.body
      body = body.gsub('{{user_email}}', admin_user.email.to_s)
                  .gsub('{{otp}}', admin_user.otp.to_s)
                  .gsub('{{info_url}}', @info_url.to_s)
      header = BxBlockDatabase::EmailTemplateHeader.where(enable: true).last
      footer = BxBlockDatabase::EmailTemplateFooter.where(enable: true).last          
      mail(from: email_template.from, to: admin_user.email, subject: email_template.subject) do |format|
        format.html { render partial: 'layouts/mail_template', locals: { body: body, header: header, footer: footer } }
      end
    end

    def send_creds(admin , password)
      email_template = find_email_template_by_label(action_name)
      return unless email_template
      body = email_template.body
      login_url = ENV['REMOTE_URL']
      body = body.gsub('{{user_email}}', admin.email.to_s)
                  .gsub('{{user_password}}', password.to_s)
                  .gsub('{{login_url}}', "#{login_url}/admin/login")
      header = BxBlockDatabase::EmailTemplateHeader.where(enable: true).last
      footer = BxBlockDatabase::EmailTemplateFooter.where(enable: true).last          
          
      mail(from: email_template.from, to: admin.email, subject: email_template.subject) do |format|
        format.html { render partial: 'layouts/mail_template', locals: { body: body, header: header, footer: footer } }
      end
    end

    private
    def find_email_template_by_label(label)
      BxBlockDatabase::EmailTemplate.find_by(label: label)
    end
  end
end