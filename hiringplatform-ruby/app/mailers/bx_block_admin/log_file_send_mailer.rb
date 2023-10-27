module BxBlockAdmin
    class LogFileSendMailer < ApplicationMailer
      before_action :set_values

      def send_file
        fetch_email()
      end

      def current_executing_file(uploaded_files)
        mail(subject: 'Current in progress file.',
             from: 'info@xcelyst.com',
             to: "vishwa.bhushan@xcelyst.com",
             body: "Hi,
             Current in-progress files are:
              #{uploaded_files.map{|a| a[:file_name]}.join(', ')}
            Thanks")
      end
    end
  end
