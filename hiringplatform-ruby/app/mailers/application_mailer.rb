class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  before_action :attach_logo

  private

  def attach_logo
    attachments.inline['xcelyst_logo.png'] = File.read("#{Rails.root}/app/assets/images/xcelyst_logo.png")
  end
end
