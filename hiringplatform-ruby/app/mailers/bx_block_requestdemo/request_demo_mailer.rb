module BxBlockRequestdemo
    class RequestDemoMailer < ApplicationMailer
      def admin_inform
        fetch_email('admin_inform')
      end

      def user_inform
        fetch_email('user_inform', @record.email)
      end
    end
end
