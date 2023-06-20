require 'csv'

namespace :import do
  desc 'Import email templates'
  task email_template: :environment do
    file = "#{Rails.root}/email-template.csv"  # Update with the actual path to your CSV file
    begin
      CSV.foreach(file, headers: true) do |row|
        BxBlockDatabase::EmailTemplate.create(row.to_h)
      end    
    rescue StandardError => e
      puts e.message
    end
  end
end
