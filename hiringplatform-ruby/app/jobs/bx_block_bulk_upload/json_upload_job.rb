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