module BxBlockBulkUpload
  class ResumeUploadJob < BxBlockBulkUpload::ApplicationJob 
    queue_as :default

    def perform(f_name)
      logs = []
      @count = 0

      ext = f_name.split('.').last
      # path = Rails.root.join("public/uploads/#{f_name}")
      # if File.exists?(path)
      if (ext == "pdf" || ext == "docx" || ext == "doc")
        begin
          BxBlockBulkUpload::ResumeUpload.process_resume_parsing(f_name)
          @count += 1
        rescue => exception
          logs << {file_name: f_name, error: exception}
        end
      # elsif ext == "txt"
      # BxBlockBulkUpload::DatabaseUser.save_database_user(path)
      end
      s3 = Aws::S3::Client.new
      s3.delete_object(bucket: ENV["AWS_BUCKET"], key: file_name) rescue nil
      logs_file = OpenStruct.new(count: @count, exceptions: logs)
      send_email(logs_file)
      
    end

    def send_email(logs)
      if logs[:errors].nil?
        failed_count = 0
        failed_detail = []
      else
        failed_count = logs[:errors].count
        failed_detail = logs[:errors]
      end
      BxBlockAdmin::LogFileSendMailer.with(successed: logs[:count], failed: failed_count, failed_detail: failed_detail, log_file: logs[:file]).send_file.deliver_now
    end
  end
end
