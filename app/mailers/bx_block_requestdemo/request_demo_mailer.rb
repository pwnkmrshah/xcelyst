module BxBlockRequestdemo
    class RequestDemoMailer < ApplicationMailer
      def contact_you
        @email = params[:email]
        mail(to: @email, from: 'builder.bx_dev@engineer.ai', subject: 'Request for Demo', body: "A Member of the Team Will be in Contact With you")
      end

      def admin_inform
        @email = "info@xcelyst.com"
        name = params[:name]
        mail(to: @email, subject: "Request for Demo", body: "#{name} requested for the Demo")
      end
    end
end
  