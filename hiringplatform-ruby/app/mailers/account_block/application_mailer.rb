module AccountBlock
  class ApplicationMailer < BuilderBase::ApplicationMailer
    include EmailHelper
    before_action :set_values

    default from: 'info@xcelyst.com'
    layout 'mailer'
  end
end
