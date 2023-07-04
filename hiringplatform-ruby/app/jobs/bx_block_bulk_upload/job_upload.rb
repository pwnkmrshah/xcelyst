module BxBlockBulkUpload
  class JobUpload < BxBlockBulkUpload::ApplicationJob 
    queue_as :default

    def perform(f_name, company_id = nil)
      begin
        ext = f_name.split('.').last
        logs = BxBlockBulkUpload::JobDatabase.save_job(f_name, company_id)# if ext == "txt"
      rescue => e
        # Log the exception
        puts "An error occurred: #{e.message}"
      end
      # send_logs_email(logs) if logs.present?
    end

    def send_logs_email(logs)
            BxBlockAdmin::LogFileSendMailer.with(successed: logs[:count], failed: logs[:errors].count, failed_detail: logs[:errors], log_file: logs[:file]).send_file.deliver_now
    end
  end
end
