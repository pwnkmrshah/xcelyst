# frozen_string_literal: true

module BxBlockBulkUpload
  class ResumeUploadJob < BxBlockBulkUpload::ApplicationJob
    queue_as :default
    $logs = []

    def unique_args(uploaded_files)
      ['resume_upload_job']
    end

    def perform(uploaded_files)
      lock_key = unique_args(uploaded_files).join(':')
      lock_value = SecureRandom.uuid

      redis = Redis.new(url: ENV['REDIS_URL'])

      if redis.setnx(lock_key, lock_value)
        begin
          start_time = Time.now # Record the start time
          uploaded_files.each do |file|
            process_uploaded_file(file)
          end
          process_final_files(uploaded_files)
          end_time = Time.now # Record the end time
          execution_time = end_time - start_time
          p "Job completed in #{execution_time} seconds."
        ensure
          # Remove the lock only if the lock value matches the expected value
          if redis.get(lock_key) == lock_value
            redis.del(lock_key)
          end
        end
      else
        # Re-enqueue the job after a delay if another job is already running
        self.class.set(wait: 1.minutes).perform_later(uploaded_files)
      end
    end
  
    private
    def process_uploaded_file(file)
      f_name = file[:file_name]
      ext = f_name.split('.').last

      return unless %w[pdf docx doc].include?(ext)

      begin
        p "Current in-progress file #{f_name}"
        BxBlockBulkUpload::ResumeUpload.process_resume_parsing(f_name)
        p "File processing succeeded #{f_name}"
        increment_upload_count
      rescue StandardError => e
        p "Current exception file #{f_name}"
        $logs << { file_name: f_name, error: e }
      end
    end

    def process_final_files(uploaded_files)
      last_file = uploaded_files.last

      return unless last_file[:is_last_file]

      p 'All files processed.'

      s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'])
      bucket_name = ENV['AWS_BUCKET']

      uploaded_files.each do |file|
        s3.delete_object(bucket: bucket_name, key: file[:file_name])
      end

      logs_file = OpenStruct.new(count: current_upload_count, exceptions: $logs)
      send_email(logs_file)
      reset_upload_count_to_zero
    end

    def send_email(logs)
      exceptions = logs[:exceptions] || []
      failed_count = exceptions.count { |entry| entry.key?(:error) }
      failed_detail = exceptions

      BxBlockAdmin::LogFileSendMailer.with(
        successed: logs[:count] || 0,
        failed: failed_count,
        failed_detail: failed_detail,
        log_file: logs[:file]
      ).send_file.deliver_now

      $logs = []
    end


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
