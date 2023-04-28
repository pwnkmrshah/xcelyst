require 'open-uri'
require 'json'
require 'httparty'


namespace :import_jobs do
  desc 'Import job data from JSON files for all companies'
  task :all_companies => :environment do
    puts "\n"
    puts "Running import_jobs:all_companies rake task at #{Time.zone.now}"
    puts "\n"
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
