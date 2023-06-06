module BxBlockRequestdemo
    class RequestDemoMailer < ApplicationMailer
      def contact_you
        @email = params[:email]
        @account = Account.find_by(email: params[:email])
        mail(to: @email, subject: 'Thank you for your interest in Xcelyst!')
      end

      def admin_inform
        @email = "info@xcelyst.com"
        name = params[:name]
        mail(to: @email, subject: "Request for Xcelyst Platform Demo")
      end
    end
end
