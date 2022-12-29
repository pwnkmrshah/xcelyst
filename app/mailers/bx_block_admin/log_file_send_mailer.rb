module BxBlockAdmin
    class LogFileSendMailer < ApplicationMailer
  
      def send_file(subject,body, logs)
        attachments['log.txt'] = logs.to_s
        mail(to: "info@xcelyst.com", from: 'builder.bx_dev@engineer.ai', subject: subject, body: body)
      end
  
    end
  end
    