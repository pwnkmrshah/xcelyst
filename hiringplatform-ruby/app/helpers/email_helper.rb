module EmailHelper
  private

  def set_values
    return nil if params.nil?

    @host = ENV['REMOTE_URL']
    set_account_values if params[:account_id] || params[:email]
    set_demo_values if params[:demo]
    set_contact_values if params[:contact]
    set_interview_values if params[:interview]
    set_default_values unless params[:interview]

    @logfile = params[:log_file].to_s
    @successed = params[:successed]
    @failed = params[:failed]
    @jd = params[:obj]
    set_jd_values if @jd.present?

    @info_url = ActionController::Base.helpers.link_to("info@xcelyst.com", '#')
    @header = BxBlockDatabase::EmailTemplateHeader.where(enable: true).last
    @footer = BxBlockDatabase::EmailTemplateFooter.where(enable: true).last
  end

  def find_email_template_by_label(label)
    BxBlockDatabase::EmailTemplate.find_by(label: label)
  end

  def replace_placeholders(body)
    placeholders = {
      '{{user_name}}' => @user_name.to_s,
      '{{user_email}}' => @user_email.to_s,
      '{{user_password}}' => @password.to_s,
      '{{phone_number}}' => @phone_number.to_s,
      '{{message}}' => @message.to_s,
      '{{otp}}' => @otp.to_s,
      '{{info_url}}' => @info_url.to_s,
      '{{url}}' => @change_password_url.to_s,
      '{{jd_role_account_name}}' => @jd_role_account_name.to_s,
      '{{jd_job_type}}' => @jd_job_type.to_s,
      '{{jd_url}}' => @jd_url.to_s,
      '{{client_name}}' => @client_name.to_s,
      '{{job_title}}' => @job_title.to_s,
      '{{success_count}}' => @successed.to_s,
      '{{failed_count}}' => @failed.to_s,
      '{{interviewer_name}}' => @interviewer_name.to_s,
      '{{feedback_link}}' => @feedback_link.to_s
    }

    placeholders.each do |placeholder, value|
      body&.gsub!(placeholder, value)
    end

    body
  end

  def send_email(from, to, subject, body)
    to_email = if @record.respond_to?(:email)
                @record.email.present? ? @record.email : 'info@xcelyst.com'
               else
                'info@xcelyst.com'
               end
    to = to.present? ? to : to_email
    subject = replace_placeholders(subject)

    attachments['logs.txt'] = @logfile if @logfile.present?

    mail(from: from, to: to, subject: subject) do |format|
      format.html { render partial: 'layouts/mail_template', locals: { body: body, header: @header, footer: @footer } }
    end
  end

  def fetch_email(label, to=nil)
    email_template = find_email_template_by_label(label)
    if to.nil?
      to = email_template.to.present? ? email_template.to : 'info@xcelyst.com'
    end
    return unless email_template

    body = replace_placeholders(email_template.body)
    send_email(email_template.from, to, email_template.subject, body)
  end

  def set_account_values
    if params[:account_id].present?
      @record = AccountBlock::Account.find_by(id: params[:account_id])
    elsif params[:email].present?
      @record = AccountBlock::Account.find_by(email: params[:email])
    end

    @otp = @record.otp
    @change_password_url = "#{@host}/account_block/accounts_setpassword?token=#{@record.reset_password_token}"
    # @change_password_url = ActionController::Base.helpers.link_to('Change password', change_password_url.to_s)
  end

  def set_demo_values
    @record = params[:demo]
    @phone_number = @record.phone_no
  end

  def set_contact_values
    @record = params[:contact]
    @phone_number = @record.phone_number
    @message = @record.description
  end

  def set_interview_values
    @record = params[:interview]
    @user_email = @record.candidate.email
    @user_name = @record.candidate.user_full_name
    @client_email = @record.client.email
    @client_name = @record.client.user_full_name
    @job_title = @record.role.job_description.job_title
    @interviewer_name = @record.interviewer.name
    token = BuilderJsonWebToken.encode @record.id, 'interviewer'
    @feedback_link = (ENV["FRONT_END_URL"] ? ENV["FRONT_END_URL"] + "candidate-feedback/" : "https://hiringplatform-74392-react-native.b74392.dev.us-east-1.aws.svc.builder.cafe/candidate-feedback/") + token
  end

  def set_default_values
    @password = params[:pass] if params[:pass].present?
    @user_name = @record&.user_full_name
    @user_email = @record&.email
  end

  def set_jd_values
    @jd_role_account_name = @jd.role.account.user_full_name
    @jd_job_type = @jd.jd_type
    @jd_url = @host + Rails.application.routes.url_helpers.rails_blob_url(@jd.jd_file, only_path: true)
  end
end