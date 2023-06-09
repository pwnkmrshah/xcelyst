module BxBlockRequestdemo
    class RequestDemoMailer < ApplicationMailer
      def contact_you
        @email = params[:email]
        @account = Account.find_by(email: params[:email])
        mail(to: @email, subject: 'Thank you for your interest in Xcelyst!')
      end

      def admin_inform
        @email = "info@xcelyst.com"
        @name = params&.first_name
        @user_email = params&.email
        @phone = params&.phone_no

        mail(to: @email, subject: 'Request for Xcelyst Platform Demo.') do |format|
          format.html { render 'admin_inform' }
        end
      end

      def user_inform
        @email = "info@xcelyst.com"
        @name = params&.first_name
        @user_email = params&.email
        @phone = params&.phone_no

        mail(to: @user_email, subject: 'Thank you for your interest in Xcelyst!') do |format|
          format.html { render 'user_inform' }
        end
      end
    end
end
