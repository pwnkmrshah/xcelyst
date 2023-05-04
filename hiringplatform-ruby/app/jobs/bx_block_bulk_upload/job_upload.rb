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
      file_name = File.basename(logs[:file])
      logs_file = logs[:logs]
      subject = "File data uploaded. Some file got rejected due to exception. Check logs."
      body = "#{logs[:success_count]} jobs uploaded successfully. #{logs[:exception_count]} jobs has some exception."
      BxBlockAdmin::LogFileSendMailer.send_file(subject, body, logs_file, file_name).deliver_now
    end
  end
end
