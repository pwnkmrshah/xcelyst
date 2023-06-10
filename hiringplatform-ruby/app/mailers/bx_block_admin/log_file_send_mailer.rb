module BxBlockAdmin
    class LogFileSendMailer < ApplicationMailer
  
      def send_file(logs, file_name)
        subject = 'File Upload Report: Rejected Files and Upload Status'
        @success_file_count = logs&.count
        @failed_file_count = logs&.exceptions&count
        attachments[file_name] = logs.to_s
        mail(to: (ENV['EMAIL_ADDRESS'] || "info@xcelyst.com"), subject: subject, body: body)
      end
  
    end
  end
