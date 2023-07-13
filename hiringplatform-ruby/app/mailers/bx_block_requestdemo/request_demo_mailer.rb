module BxBlockRequestdemo
    class RequestDemoMailer < ApplicationMailer
      def admin_inform
        fetch_email()
      end

      def user_inform
        fetch_email(@record.email)
      end
    end
end
