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
      BxBlockAdmin::LogFileSendMailer.send_file(logs, 'logs.txt').deliver_now
    end
  end
end