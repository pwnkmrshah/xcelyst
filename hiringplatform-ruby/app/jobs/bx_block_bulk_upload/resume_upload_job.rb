module BxBlockBulkUpload
  class ResumeUploadJob < BxBlockBulkUpload::ApplicationJob 
    queue_as :default

    def perform(file_names)
      logs = []
      @count = 0
      file_names.each do |name|
        ext = name.split('.').last
        # path = Rails.root.join("public/uploads/#{name}")
        # if File.exists?(path)
          if (ext == "pdf" || ext == "docx" || ext == "doc")
            begin
              BxBlockBulkUpload::ResumeUpload.process_resume_parsing(name)
              @count += 1
            rescue => exception
              logs << {file_name: name, error: exception}
            end
          # elsif ext == "txt"
          # BxBlockBulkUpload::DatabaseUser.save_database_user(path)
          end
          s3 = Aws::S3::Client.new
          s3.delete_object(bucket: ENV["AWS_BUCKET"], key: file_name) rescue nil
      end
      logs_file = OpenStruct.new(count: @count, exceptions: logs)
      send_email(logs_file)
    end

    def send_email(logs)
      BxBlockAdmin::LogFileSendMailer.send_file(logs, 'logs.txt').deliver_now
    end
  end
end
