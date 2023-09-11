module BxBlockShortlisting
  class ShortlistingCandidatesController < ApplicationController
    def get_jd
      role_ids = BxBlockRolesPermissions::Role.where(account_id: params[:id], is_closed: false).ids
      client_jds = BxBlockJobDescription::JobDescription.where(role_id: role_ids)
      jds_hash = []
      client_jds.map do |jd|
        rec = {
          id: jd.id,
          job_title: jd.role.name,
        }
        jds_hash << rec
      end
      render json: { data: jds_hash }, status: 200
    end

    def get_roles
      jd = BxBlockJobDescription::JobDescription.find_by(id: params[:id])
      url = "#"
      if jd && jd.sovren_ui_url.present?
        url = jd&.sovren_ui_url
      end

      check_sov_url = URI.parse("https://eu-rest.resumeparsing.com/ui/v10/#{url}")
      response = Net::HTTP.get_response(check_sov_url)

      if response.is_a?(Net::HTTPSuccess)
        puts "URL is accessible"
      else
        puts "URL is not accessible"
        url = update_sov_url(jd) if jd.present?
      end

      render json: { data: url }, status: 200
    end

    def update_sov_url(jd)
      data =  { "UIOptions" =>  { "Username" =>  "namita.akhauri@xcelyst.com", "ShowBanner" => true, "SovScoreName" => "XcelystScore" }, "SaasRequest" => {"IndexIdsToSearchInto" => ["1", "resume_index", "bulk_uplod_index"] }, "ParseOptions" => {}, "GeocodeOptions"=> {} }.to_json

      uri = URI.parse("https://eu-rest.resumeparsing.com/ui/v10/matcher/indexes/jd001/documents/#{jd.document_id}")
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true

      headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Sovren-AccountId' => ENV['SOVREN_ID'] || '14044560', # use your account id here
        'Sovren-ServiceKey' => ENV['SOVREN_KEY'] || 'qQ8I+UkWFIRC0p9fx0GDq5wDCAw75mgNJERyB+RO', # use your service key here
      }
      req = Net::HTTP::Post.new(uri.path, initheader = headers)
      req.body = data
      res = https.request(req)
      sovren_url = JSON.parse(res.body)
      sovren_url.fetch("url")
    end

    def get_candidate
      applied_jobs = BxBlockRolesPermissions::AppliedJob.where(role_id: params[:id])
      candidate_hash = []
      applied_jobs && applied_jobs.map do |job|
        rec = {
          id: job.profile.account.id,
          name: "#{job.profile.account.first_name} #{job.profile.account.last_name}",
        }
        candidate_hash << rec
      end
      render json: { data: candidate_hash }, status: 200
    end

    
    # Create by Punit 
    # Send a Message on Whatsapp this method for Admin bulk Message For Candidate
    def bulk_send_messages_to_account
      if params[:accounts].present? && params[:message].present?
        params[:accounts] -= %w{undefined}
        users  = AccountBlock::Account.where(id: params[:accounts])
        users.present? && users.map do |user|
          chat = BxBlockWhatsapp::WhatsappChat.find_or_create_by(
						user_id: user.id,
						user_type: user.class.name,
						admin_user_id: UserAdmin.first.id
					)
					messages = BxBlockWhatsapp::WhatsappMessage.create(
						whatsapp_chat_id: chat.id,
						message: params[:message],
						sender_type: "UserAdmin",
						sender_id: UserAdmin.first.id,
						receiver_type: user.class.name,
						receiver_id: user.id
					)
          response = Faraday.send('post') do |req|
            req.headers[:Content_Type] = 'application/json'
            req.headers[:Authorization] = ENV["WHATSAPP_TOKEN"]
            req.url ENV["WHATSAPP_MESSAGE_URL"]
            req.body = JSON.dump({
              "messaging_product": "whatsapp",
              "to": user.phone_number,
              "type": "template",
              "template": {
                  "name": "admin_custom_message",
                  "components": [
                    {
                      "type": "body",  
                      "parameters": [{ "type": "text", "text": "#{params[:message]}" }],
                    }],
                  "language": {
                      "code": "en"
                  }
              }
            })
          end
          if response.status == 400
            obj = JSON.parse(response.body)
            return render json: {"message": obj.dig("error", "error_data", "details")}, status: :ok
          end
        end
        render json: {"message": "whatsapp message succesfully"}, status: :ok
      else
        render json: { error: "Something not comes" }, status: 422
      end
    end

    # Create by Punit 
    # Send a Message on Whatsapp this method for Admin bulk Message For Candidate
    def bulk_send_messages
      if params[:temporary_accounts].present? && params[:message].present?
        params[:temporary_accounts] -= %w{undefined}
        users  = AccountBlock::TemporaryAccount.where(id: params[:temporary_accounts])
        users.present? && users.map do |user|
          chat = BxBlockWhatsapp::WhatsappChat.find_or_create_by(
						user_id: user.id,
						user_type: user.class.name,
						admin_user_id: UserAdmin.first.id
					)
					messages = BxBlockWhatsapp::WhatsappMessage.create(
						whatsapp_chat_id: chat.id,
						message: params[:message],
						sender_type: "UserAdmin",
						sender_id: UserAdmin.first.id,
						receiver_type: user.class.name,
						receiver_id: user.id
					)
          response = Faraday.send('post') do |req|
            req.headers[:Content_Type] = 'application/json'
            req.headers[:Authorization] = ENV["WHATSAPP_TOKEN"]
            req.url ENV["WHATSAPP_MESSAGE_URL"]
            req.body = JSON.dump({
              "messaging_product": "whatsapp",
              "to": user.phone_no,
              "type": "template",
              "template": {
                  "name": "admin_custom_message",
                  "components": [
                    {
                      "type": "body",  
                      "parameters": [{ "type": "text", "text": "#{params[:message]}" }],
                    }],
                  "language": {
                      "code": "en"
                  }
              }
            })
          end
        end
        if response.status == 400
          obj = JSON.parse(response.body)
          return render json: {"message": obj.dig("error", "error_data", "details")}, status: :ok
        end
        render json: {"message": "whatsapp message succesfully"}, status: :ok
      else
        render json: { error: "Something not comes" }, status: 422
      end
    end

    def shortlist_creation
      if params[:shortlist_users].present? && !params[:shortlist_users].first.blank? && params[:client_id].present? && params[:jd_id].present?
        count = 0
        params[:shortlist_users] -= %w{undefined}
        params[:shortlist_users].each do |record|
          @short_candidate = ShortlistingCandidate.new(client_id: params[:client_id], job_description_id: params[:jd_id], candidate_id: record, is_shortlisted: true)
          count += 1 if @short_candidate.save
          candidate = AccountBlock::Account.find(record)
          jd = BxBlockJobDescription::JobDescription.find(params[:jd_id])
          applied_job = BxBlockRolesPermissions::AppliedJob.find_or_create_by(profile_id: candidate.profile.id, role_id: jd.role.id, shortlisting_candidate_id: @short_candidate.id)

          ##sovren score
          update_sov_score(params, candidate, jd)

          ## FORAMTHAKRAL
          ## TEMPORARY ADDED CODE HERE TO TEST
          url = "https://eu-rest.resumeparsing.com/v10/matcher/joborder"
          jd_data = jd.parsed_jd['Value'].present? ? jd.parsed_jd['Value'] : jd.parsed_jd['JobData'] 
          data =  { "JobData" => jd_data, "IndexIdsToSearchInto" => [ "resume_index", "1", "bulk_uplod_index"] }.to_json
          
          uri = URI.parse("#{url}")
          https = Net::HTTP.new(uri.host,uri.port)
          https.use_ssl = true

          headers = {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
            'Sovren-AccountId' => ENV['SOVREN_ID'] || '14044560', # use your account id here
            'Sovren-ServiceKey' => ENV['SOVREN_KEY'] || 'qQ8I+UkWFIRC0p9fx0GDq5wDCAw75mgNJERyB+RO', # use your service key here
          }

          req = Net::HTTP::Post.new(uri.path, initheader = headers)
          req.body = data
          res = https.request(req)
           
          # Parse the response body into an object
          respObj = JSON.parse(res.body)
          if respObj['Value']["Matches"].present?
            respObj['Value']["Matches"].each do |a|
              user = AccountBlock::UserResume.find_by(document_id: a["Id"])
              temp_user = AccountBlock::TemporaryAccount.find_by(document_id: a["Id"])
              if user.present?
                user.update(sovren_score: a["SovScore"])
              elsif temp_user.present?
                 temp_user.update(sovren_score: a["SovScore"])
              end   
            end
          end
        end
        if count > 0
          render json: { message: "Candidate has been shortlisted for above selected JD." }, status: 200
        else
          render json: { error: @short_candidate.errors.full_messages }, status: 422
        end
      else
        render json: { error: "Please select all the required fields." }, status: 422
      end
    end

    def update_sov_score(params, candidate, jd)
      user = ShortlistingCandidate.find_by(job_description_id: params[:jd_id], candidate_id: candidate&.id)
      # ======================================================================================
      # For Fetch a score from sovren
      # ======================================================================================
      # doc_id = "#{@user_resume.document_id}".downcase
      uri = "https://eu-rest.resumeparsing.com/v10/matcher/indexes/1/documents/#{candidate&.document_id}"
      data =  { "IndexIdsToSearchInto" => [ "jd001" ], FilterCriteria: { DocumentIds: ["#{jd&.document_id}"]} }.to_json
      score_rs = send_post_req uri,data
      print "========#{jd&.document_id}============================================"
      # TO STORE A SOVREN SCORE IN THE TABLE
      if score_rs.present?
        if score_rs["Value"]["Matches"].present?
          score_rs["Value"]["Matches"].each do |jd_id|
            if user.present?
              user.update(sovren_score: jd_id['SovScore'])
            end  
          end  
        end
      end
    end

    def send_post_req url, data
      uri = URI.parse("#{url}")
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true

      headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Sovren-AccountId' => ENV['SOVREN_ID'] || '14044560', # use your account id here
        'Sovren-ServiceKey' => ENV['SOVREN_KEY'] || 'qQ8I+UkWFIRC0p9fx0GDq5wDCAw75mgNJERyB+RO', # use your service key here
      }

      req = Net::HTTP::Post.new(uri.path, initheader = headers)
      req.body = data
      res = https.request(req)
      # Parse the response body into an object
      respObj = JSON.parse(res.body) if res.body.present? && res.msg == "OK"
    end

    def get_shortlisted
      @short_candidates = ShortlistingCandidate.shortlisted_candidates(params[:client_id], params[:jd_id]).pluck(:candidate_id)
      return render json: { candidate_ids: @short_candidates }, status: 200
    end

    def attach_temp_resume_file
      begin
        obj  = AccountBlock::TemporaryAccount.find_by(id: params[:id])
        obj.resume_file.purge
        file_name = "#{SecureRandom.hex(6)}#{params[:file_name]}"
        s3 = Aws::S3::Client.new
        resp = s3.get_object(bucket: ENV["AWS_BUCKET"], key: params[:file_name])
        obj.resume_file.attach(io: resp.body, filename: file_name, content_type: 'application/pdf')
        render json: {message: "file attaced"}, status: :ok
      rescue => exception
        render json: {message: exception}, status: 422
      end
    end

    def create_parsed_json_file
      record = AccountBlock::TemporaryAccount.find_by(id: params[:id])
      begin
        create_directory_if_not_exist
        file_name = "temp-account-#{SecureRandom.hex(20)}.txt"
        file_path = "#{@directory_name}/#{file_name}"
        my_file = File.open("#{file_path}", "w")

        my_file.write params[:file_data]

        my_file.close

        record.parse_resume.attach(
          io: File.open("#{file_path}"),
          filename: "#{file_name}",
          content_type: 'application/txt',
          identify: false
        )
        
        File.delete(file_path)
        render json: {message: "file attaced"}, status: :ok
        rescue => exceptions
          render json: {message: exception}, status: 422
        end
    end

    def create_directory_if_not_exist
      @directory_name = "public/temp_account"
      Dir.mkdir(@directory_name) unless File.exists?(@directory_name)
    end

  end
end
