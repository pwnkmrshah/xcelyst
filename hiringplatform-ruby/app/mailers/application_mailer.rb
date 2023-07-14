class ApplicationMailer < ActionMailer::Base
  include EmailHelper

  default from: 'info@xcelyst.com'
  layout 'mailer'

end
