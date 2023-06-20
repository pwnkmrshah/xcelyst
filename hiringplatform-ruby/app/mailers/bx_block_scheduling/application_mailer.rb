module BxBlockScheduling
  class ApplicationMailer < BuilderBase::ApplicationMailer
    before_action :set_values

    default from: 'from@example.com'
    layout 'mailer'
  end
end
