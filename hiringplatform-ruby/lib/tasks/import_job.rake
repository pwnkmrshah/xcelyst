require 'open-uri'
require 'json'
require 'httparty'


namespace :import_jobs do
  desc 'Import job data from JSON files for all companies'
  task :all_companies => :environment do
    companies_url = "#{ENV['GET_COMPANY_URL']}/api/get/companies"
    response = HTTParty.get(companies_url)
    companies_json = JSON.parse(response.body)["data"]
    companies_json.each do |company|
      puts "START"
      puts "company: #{company}"
      BxBlockBulkUpload::CompanyJobsUpload.perform_later(company['id'])
      puts "DONE \n"
    end
  end
end
