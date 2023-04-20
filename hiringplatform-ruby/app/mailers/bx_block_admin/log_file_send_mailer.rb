module BxBlockAdmin
    class LogFileSendMailer < ApplicationMailer
  
      def send_file(subject, body, logs, file_name)
        attachments[file_name] = logs.to_s
        mail(to: ENV['EMAIL_ADDRESS'], from: 'builder.bx_dev@engineer.ai', subject: subject, body: body)
      end
  
    end
  end
    