module BxBlockContactUs
  class ApplicationMailer < BuilderBase::ApplicationMailer
    before_action :set_values

    default from: 'info@xcelyst.com'
    layout 'mailer'
  end
end
