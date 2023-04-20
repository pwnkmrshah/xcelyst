module BxBlockBulkUpload
  class JobDatabase
    class << self

      # create by Nishu Jain
      # this method is used to save the json file records into database.
      # all the records should be differentiate by the uid field which is unique and any uid present already
      # in the db. It will update that record.
      def save_job(file, company_id = nil)
        file_content = File.read(file)
        return nil if file_content.blank? || company_id.nil?

        data = JSON.parse(file_content)

        # Access the data
        jobs = data['data']
        
        success_count = 0 # Keep track of successful insertions
        exception_count = 0 # Keep track of exceptions
        
        logs = [] # Keep track of exception records and their reasons

        # puts "Start: Destroying all BxBlockJob::JobDatabase for company_uid = #{company_id}"
        # # Destroy all job for particular company_id
        # # Because Python API scrap in every 3 days, we will not this particular company_id until then
        # # Once we have new data, then we will insert again by below "each" loop
        # BxBlockJob::JobDatabase.where(company_uid: company_id).destroy_all
        # puts "End: Destroying all BxBlockJob::JobDatabase for company_uid = #{company_id}"

        jobs.each do |job|
          begin
            BxBlockJob::JobDatabase.create!(
              company_uid: job['company_id'],
              company_name: job['company_name'],
              url: job['url'],
              job_uid: job['id'],
              job_title: job['job_title'],
              location: job['location'],
              date_published: job['date_published'],
              business_area: job['business_area'],
              area_domain: job['area_domain'],
              reference_code: job['reference_code'],
              employment: job['employment'],
              responsibilities: job['responsibilities'],
              skills: job['skills'],
              apply_for_job_url: job['apply_for_job_url'],
              description: job['description']&.flatten!
            )
            success_count += 1
          rescue => e
            exception_count += 1
            logs << { id: job['id'], reason: e.message } # Add the exception record ID and reason to the logs array
          end
        end

        # TODO: If exception_count is Zero, then call a Python API to update this particular company_id status
        # So that, in next iteration we do not fetch this particular company until next scraping at Python API
        # Once Python API will do another scraping, again we will get the updated data. We will go same again.

        # Return a hash with the success and exception counts and the logs
        { success_count: success_count, exception_count: exception_count, logs: logs, file: file}
      end
    end
  end
end
