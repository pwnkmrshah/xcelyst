module BxBlockScheduling
  class ApplicationMailer < BuilderBase::ApplicationMailer
    include EmailHelper
    before_action :set_values

    default from: 'from@example.com'
    layout 'mailer'
  end
end
