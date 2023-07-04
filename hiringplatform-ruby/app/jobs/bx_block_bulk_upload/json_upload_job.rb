module BxBlockBulkUpload
  class JsonUploadJob < BxBlockBulkUpload::ApplicationJob 
    queue_as :default

    def perform(f_name)
      ext = f_name.split('.').last
      # # path = Rails.root.join("public/uploads/#{f_name}")
      # # if File.exists?(path)
      if ext == "txt"
        begin
          logs = BxBlockBulkUpload::DatabaseUser.save_database_user(f_name)
        rescue => exception
          s3 = Aws::S3::Client.new
          s3.delete_object(bucket: ENV["AWS_BUCKET"], key: f_name) rescue nil
          logs = OpenStruct.new(exceptions: exception)
        end
        send_email(logs)
      end
    end

    def send_email(logs)
      BxBlockAdmin::LogFileSendMailer.with(successed: logs[:count], failed: logs[:errors].count, failed_detail: logs[:errors], log_file: logs[:file]).send_file.deliver_now
    end
  end
end