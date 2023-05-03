module BxBlockBulkUpload
  class AllCompaniesFetchWorker
    include Sidekiq::Worker

    def perform
      companies_url = "#{ENV['GET_COMPANY_URL']}api/get/companies?env=#{ENV['RAILS_ENV']}"
      response = HTTParty.post(
        companies_url,
        body: {
          env: ENV['RAILS_ENV']
        }
      )
      if response.code == 200
        companies_json = JSON.parse(response.body)["data"]
        companies_json.each do |company|
          puts "START"
          puts "company: #{company}"
          BxBlockBulkUpload::CompanyJobsUpload.perform_later(company['id'])
          puts "DONE \n"
        end
      else
        puts "GET Comapnies API not worked properly, getting response: #{response}"
      end
    end
  end
end
