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
      if logs&.errors&.blank? && logs&.count > 0
        logs_file = logs&.errors
        subject = "File data uploaded successfully"
        body = "#{logs&.count} resume uploaded successfully "
      else
        logs_file = logs.errors&.map{|a| [a[:id], a[:errors]] }.to_h
        subject = "File now uplaoded some erros occured"
        body = "#{logs&.count} resume uploaded successfully please check the logs for the remaining data"
      end
      BxBlockAdmin::LogFileSendMailer.send_file(subject, body, logs_file).deliver_now
    end
  end
end