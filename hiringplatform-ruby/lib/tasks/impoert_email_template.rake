namespace :import do
  desc 'Import email templates'
  task email_template: :environment do
    file = "#{Rails.root}/email-template.csv"  # Update with the actual path to your CSV file
    begin
      CSV.foreach(file, headers: true) do |row|
        attributes = row.to_h
        label = attributes.delete('label')
        email_template = BxBlockDatabase::EmailTemplate.find_or_create_by(label: label) do |et|
          et.assign_attributes(attributes)
          et.id ||= BxBlockDatabase::EmailTemplate.maximum(:id).to_i + 1
          et.save(validate: false)
        end
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
