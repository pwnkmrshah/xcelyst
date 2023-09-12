module BxBlockBulkUpload
  class ResumeUploadJob < BxBlockBulkUpload::ApplicationJob 
    queue_as :default

    $logs = []

    def perform(f_name, is_last_file)
      ext = f_name.split('.').last
      # path = Rails.root.join("public/uploads/#{f_name}")
      # if File.exists?(path)
      if (ext == "pdf" || ext == "docx" || ext == "doc")
        begin
          BxBlockBulkUpload::ResumeUpload.process_resume_parsing(f_name)
          increment_upload_count # Increment the count for a successful upload
        rescue => exception
          $logs << {file_name: f_name, error: exception}
        end
      # elsif ext == "txt"
      # BxBlockBulkUpload::DatabaseUser.save_database_user(path)
      end
      s3 = Aws::S3::Client.new
      s3.delete_object(bucket: ENV["AWS_BUCKET"], key: file_name) rescue nil
      logs_file = OpenStruct.new(count: current_upload_count, exceptions: $logs)
      if is_last_file == true
        send_email(logs_file)
        reset_upload_count_to_zero
      end
    end

    def send_email(logs)
      if logs[:exceptions].nil?
        failed_count = 0
        failed_detail = []
      else
        failed_count = logs[:exceptions].count { |entry| entry.key?(:error) }
        failed_detail = logs[:exceptions]
      end
      BxBlockAdmin::LogFileSendMailer.with(successed: logs[:count], failed: failed_count, failed_detail: failed_detail, log_file: logs[:file]).send_file.deliver_now
      $logs = []
    end

    private

    def increment_upload_count
      Redis.current.incr('resume_upload_count')
    end

    def reset_upload_count_to_zero
      Redis.current.set('resume_upload_count', 0)
    end


    def current_upload_count
      Redis.current.get('resume_upload_count').to_i
    end

  end
end
