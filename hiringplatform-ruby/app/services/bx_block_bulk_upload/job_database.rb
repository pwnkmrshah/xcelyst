module BxBlockBulkUpload
  class JobDatabase
    class << self

      # create by Nishu Jain
      # this method is used to save the json file records into database.
      # all the records should be differentiate by the uid field which is unique and any uid present already
      # in the db. It will update that record.
      def save_job(file)
        file_content = File.read(file)
        return nil if file_content.blank?

        data = JSON.parse(file_content)

        # Access the data
        jobs = data['data']
        
        success_count = 0 # Keep track of successful insertions
        exception_count = 0 # Keep track of exceptions
        
        logs = [] # Keep track of exception records and their reasons

        jobs.each do |job|
          begin
            jd_data = BxBlockJob::JobDatabase.find_or_initialize_by(job_uid: job['id'])
            jd_data.update!(
              company_name: (job['Company_Name'] || job['company_name']),
              url: (job['url'] || job['url']),
              job_uid: (job['id'] || job['id']),
              job_title: (job['Job_Title'] || job['job_title']),
              location: (job['Location'] || job['location']),
              date_published: (job['Date_Published'] || job['date_published']),
              business_area: (job['Business_Area'] || job['business_area']),
              area_domain: (job['Area_Domain'] || job['area_domain']),
              reference_code: (job['Reference_Code'] || job['reference_code']),
              employment: (job['Employment'] || job['employment']),
              responsibilities: (job['Responsibilities'] || job['responsibilities']),
              skills: (job['Skills'] || job['skills']),
              apply_for_job_url: (job['Apply_for_job_url'] || job['apply_for_job_url']),
              description: (job['Description'] || job['description'])&.flatten!
            )
            success_count += 1
          rescue => e
            exception_count += 1
            logs << { id: job['id'], reason: e.message } # Add the exception record ID and reason to the logs array
          end
        end

        # Return a hash with the success and exception counts and the logs
        { success_count: success_count, exception_count: exception_count, logs: logs, file: file}
      end
    end
  end
end
