require 'open-uri'
require 'json'
require 'httparty'

namespace :import_jobs do
  desc 'Import job data from JSON files for all companies'
  task :all_companies => :environment do
    puts "Running import_jobs:all_companies rake task at #{Time.zone.now}"
    BxBlockBulkUpload::AllCompaniesFetchWorker.perform_async
  end
end
