module BxBlockBulkUpload
  class ResumeUpload
    class << self
      def execute(file_data)
        @count = 0
        file_data.each do |file|
          if file.content_type.include?('application/pdf')
            process_resume_parsing file
          elsif file.content_type.include?('application/docx')
            process_resume_parsing file
          elsif file.content_type.include?('application/doc')
            process_resume_parsing file
          elsif file.content_type.include?('text/plain')
            x = BxBlockBulkUpload::DatabaseUser.save_database_user(file)
            return OpenStruct.new(count: x.count)
          end
        end
        OpenStruct.new(count: @count)
      end

      def process_resume_parsing(file)
        @count = 0
        @errors = []
        # Aws s3 way
        file_path = file
        s3 = Aws::S3::Client.new
        resp = s3.get_object(bucket: ENV['AWS_BUCKET'], key: file_path)
        file_data = resp.body.read
        modified_date = resp.last_modified.to_s[0, 10]
        base_64_file = Base64.encode64(file_data)

        data = {
          'DocumentAsBase64String' => base_64_file,
          'DocumentLastModified' => modified_date
          # other options here (see https://sovren.com/technical-specs/latest/rest-api/resume-parser/api/)
        }.to_json

        uri = 'https://eu-rest.resumeparsing.com/v10/parser/resume'
        respObj = send_post_req(uri, data)
        p "Soveren response ---  #{respObj['Value']['ParsingResponse']['Code']} for #{file}"
        if %w[timeout conversionexception].include? respObj['Value']['ParsingResponse']['Code'].downcase
          exception_message = respObj['Value']['ParsingResponse']['Message']
        end
        raise exception_message if exception_message.present?

        p "exception for file #{file_path} ------- #{exception_message}" if exception_message.present?
        create_temporary_accounts respObj, file, resp # for normal flow

        # for background job process

        # create_temporary_accounts respObj, file_path, file_path.to_s.split('/').last.split('.').first
      end

      def send_post_req(url, data)
        uri = URI.parse("#{url}")
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true

        headers = {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'Sovren-AccountId' => ENV['SOVREN_ID'] || '14044560', # use your account id here
          'Sovren-ServiceKey' => ENV['SOVREN_KEY'] || 'qQ8I+UkWFIRC0p9fx0GDq5wDCAw75mgNJERyB+RO' # use your service key here
        }

        req = Net::HTTP::Post.new(uri.path, initheader = headers)
        req.body = data
        res = https.request(req)

        # Parse the response body into an object
        respObj = JSON.parse(res.body)
      end

      # def create_temporary_accounts respObj, file_path, file_name
      def create_temporary_accounts(respObj, file, resp)
        return unless respObj['Value']['ResumeData']['ResumeMetadata']['ReservedData'].present?

        email = respObj['Value']['ResumeData']['ResumeMetadata']['ReservedData']['EmailAddresses'].present? ? respObj['Value']['ResumeData']['ResumeMetadata']['ReservedData']['EmailAddresses'][0] : ''
        doc_hash = respObj['Value']['ConversionMetadata']['DocumentHash']

        if respObj['Value']['ResumeData']['ResumeMetadata']['ReservedData']['Phones'].present?
          ph_no = if respObj['Value']['ResumeData']['ResumeMetadata']['ReservedData']['Phones'][0].include?('Phone')
                    respObj['Value']['ResumeData']['ResumeMetadata']['ReservedData']['Phones'][0].split(':').last.strip
                  else
                    respObj['Value']['ResumeData']['ResumeMetadata']['ReservedData']['Phones'][0].strip
                  end
        end
        uniq_string = SecureRandom.hex(2)
        email_ac = AccountBlock::TemporaryAccount.find_by(email: email) if email.present?
        phone_ac = AccountBlock::TemporaryAccount.find_by(phone_no: ph_no) if ph_no.present?
        doc_hash_ac = AccountBlock::TemporaryAccount.find_by(document_hash: doc_hash) if doc_hash.present?
        return if doc_hash_ac.present?

        if email_ac.present?
          email_ac.update(document_hash: doc_hash, phone_no: ph_no, updated_at: Time.now)
          create_parsed_json_file respObj, email_ac
          attach_resume_file email_ac, file, resp
        elsif phone_ac.present?
          phone_ac.update(document_hash: doc_hash, email: email, updated_at: Time.now)
          create_parsed_json_file respObj, phone_ac
          attach_resume_file phone_ac, file, resp # ( for background job process  )
        else
          if respObj['Value']['ResumeData']['ResumeMetadata']['ReservedData']['Names'].present?
            full_name = respObj['Value']['ResumeData']['ResumeMetadata']['ReservedData']['Names'][0]
          end

          name = full_name.split if full_name.present?
          first_name = name[0] if name.present?
          last_name = name[1] if name.present?

          if email.present? || ph_no.present?
            record = AccountBlock::TemporaryAccount.create(first_name: first_name, last_name: last_name, email: email, phone_no: ph_no) # ( for normal process  )
          else

            temp_email = "#{full_name}#{uniq_string}@yopmail.com".downcase
            temp_email = temp_email.gsub(' ', '')
            record = AccountBlock::TemporaryAccount.create(first_name: first_name, last_name: last_name,
                                                           email: temp_email, phone_no: nil)
          end

          record.update(document_hash: doc_hash, document_id: doc_hash)
          create_parsed_json_file respObj, record

          # AccountBlock::TempAccount.create(temporary_account_id: record.id, parsed_resume: respObj)

          # record = AccountBlock::TemporaryAccount.create(first_name: name, email: email, parsed_resume: respObj, phone_no: @ph_no)  # ( for background job process )

          if record.present?
            attach_resume_file record, file, resp # ( for background job process )
            # update_document_id = record.update(document_id: uniq_string)
            update_document_hash = record.update(document_hash: doc_hash)
          end

        end
        record ||= phone_ac || email_ac
        @count += 1 if record.present? || email_ac.present? || phone_ac.present? # for normal flow

        indexing = indexing_resume respObj, record if record.present? || (doc_hash != record.document_hash)
      end

      def indexing_resume(parsed_resume, record)
        # ============================================================================================
        # TO CREATE A INDEX( Creation of Index necessary to assign created index to resume)
        # ============================================================================================
        # uri = "https://eu-rest.resumeparsing.com/v10/index/RESUME_INDEX"
        # data =  { "IndexType" => "Resume" }.to_json
        # respObj = send_post_req uri,data

        # ============================================================================================
        # TO ASSIGN A INDEX TO RESUME ALONG WITH DOCUMENT ID
        # ===========================================================================================
        url = "https://eu-rest.resumeparsing.com/v10/index/#{ENV['SOVREN_TEMPORARY_ACCOUNT_INDEX']}/resume/#{record.document_id}"
        data = { 'ResumeData' => parsed_resume['Value']['ResumeData'] }.to_json
        succ_response = send_post_req url, data
        puts "=========================#{succ_response}============================================================="
      end

      # created by akash deep
      # to upload the resume file on bucket (this is the background job part.)
      def attach_resume_file(obj, file_name, _resp)
        url = Rails.application.routes.default_url_options[:host] + '/bx_block_shortlisting/attach_temp_resume_file'
        data = { "id": obj.id, "file_name": file_name }
        response = send_post_request(url, data)
        s = JSON.parse(response.body) if response.body
        # obj.resume_file.attach(
        #             io: File.open("#{file_path}"),
        #             filename: "#{file_name}",
        #             content_type: 'application/pdf',
        #             identify: false
        #           )

        # File.delete(file_path)
      end

      # def update_parsed_resume_rec record, respObj
      #   parsed_resume_rec = AccountBlock::TempAccount.find_by(temporary_account_id: record.id)

      #   if parsed_resume_rec.present?
      #     parsed_resume_rec.update(parsed_resume: respObj,)
      #   else
      #     AccountBlock::TempAccount.create(temporary_account_id: record.id, parsed_resume: respObj)
      #   end

      # end

      def create_parsed_json_file(file_data, record)
        url = Rails.application.routes.default_url_options[:host] + '/bx_block_shortlisting/create_parsed_json_file'
        data = { "id": record.id, "file_data": file_data }
        response = send_post_request(url, data)
        s = JSON.parse(response.body) if response.body
        # create_directory_if_not_exist
        # file_name = "temp-account-#{SecureRandom.hex(20)}.txt"
        # file_path = "#{@directory_name}/#{file_name}"
        # my_file = File.open("#{file_path}", "w")

        # my_file.write "#{file_data}"

        # my_file.close

        # record.parse_resume.attach(
        #   # key: "temporary_account/#{record.id}/#{file_name}",
        #   io: File.open("#{file_path}"),
        #   filename: "#{file_name}",
        #   content_type: 'application/txt',
        #   identify: false
        # )

        # File.delete(file_path)
      rescue Exception => e
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join("\n")
      end

      def create_directory_if_not_exist
        @directory_name = 'public/temp_account'
        Dir.mkdir(@directory_name) unless File.exist?(@directory_name)
      end

      def send_post_request(uri, data)
        url   = URI(uri)
        http  = Net::HTTP.new(url.host, url.port)
        http.use_ssl      = true
        http.verify_mode  = OpenSSL::SSL::VERIFY_NONE
        request           = Net::HTTP::Post.new(url)
        request['content-type']   = 'application/json'
        request['cache-control']  = 'no-cache'
        request.body = data.to_json
        http.request(request)
      end
    end
  end
end
