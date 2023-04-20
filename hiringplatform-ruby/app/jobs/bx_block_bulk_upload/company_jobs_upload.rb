require 'open-uri'
require 'json'
require 'httparty'

module BxBlockBulkUpload
  class CompanyJobsUpload < BxBlockBulkUpload::ApplicationJob 
    queue_as :default

    def perform(company_id = nil)
      return if company_id.nil?

      companies_url = URI("#{ENV['GET_COMPANY_URL']}api/get/job/details")
      params = { company_id: company_id }
      headers = { 'Content-Type': 'application/json' }
      
      req = Net::HTTP::Post.new(companies_url, headers)
      req.body = params.to_json

      res = Net::HTTP.start(companies_url.host, companies_url.port) do |http|
        http.request(req)
      end
      res_data = JSON.parse(res.body)
      file_url = res_data['data']['json_file_url']
      get_company_data(file_url, company_id)
    end

    private

    def get_company_data(file_url, company_id)
      # Download the file and extract its contents
      temp_file = Tempfile.new('file.txt')
      temp_file.binmode
      temp_file.write(URI.open(file_url).read)
      f_name = temp_file.path
      logs = BxBlockBulkUpload::JobDatabase.save_job(f_name, company_id)
      # send_logs_email(logs) if logs.present?
      temp_file.close
      temp_file.unlink
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
