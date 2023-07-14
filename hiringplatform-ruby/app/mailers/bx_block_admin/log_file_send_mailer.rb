module BxBlockAdmin
    class LogFileSendMailer < ApplicationMailer
      before_action :set_values

      def send_file
        fetch_email()
      end  
    end
  end
