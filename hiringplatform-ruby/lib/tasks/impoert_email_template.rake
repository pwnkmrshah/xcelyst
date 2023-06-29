namespace :import do
  desc 'Import email templates'
  task email_template: :environment do
    file = "#{Rails.root}/email-template.csv"  # Update with the actual path to your CSV file
    begin
      max_id = BxBlockDatabase::EmailTemplate.maximum(:id) || 0

      CSV.foreach(file, headers: true) do |row|
        attributes = row.to_h
        attributes['id'] = max_id + 1
        email_template = BxBlockDatabase::EmailTemplate.new(attributes)
        email_template.save(validate: false)
        max_id += 1
      end
    rescue StandardError => e
      puts e.message
    end

    # Reset the primary key sequence
    table_name = BxBlockDatabase::EmailTemplate.table_name
    sequence_name = ActiveRecord::Base.connection.execute("SELECT pg_get_serial_sequence('#{table_name}', 'id')").getvalue(0, 0)
    ActiveRecord::Base.connection.execute("SELECT setval('#{sequence_name}', (SELECT MAX(id) FROM #{table_name}));")
  end
end
