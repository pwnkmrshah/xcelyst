require 'uri'
require 'net/http'
require 'net/https'
require 'base64'
require 'json'
    
module BxBlockSovren
  class Sovren

    attr_accessor :resume_file, :user, :user_id

    def initialize resume_file, user
      @resume_file = resume_file
      @user = user
      @user_id = user.id
    end

    # to parse resume
    def execute
      file_path = resume_file
      file_data = IO.binread(file_path)
      modified_date = File.mtime(file_path).to_s[0,10]
       
      # Encode the bytes to base64
      base_64_file = Base64.encode64(file_data)

      if user.user_resume.present?
        @user_resume = user.user_resume
        @user_resume.resume_file = base_64_file
      else
        @user_resume = AccountBlock::UserResume.create(resume_id: SecureRandom.uuid, account_id: user_id, resume_file: base_64_file)
      end

      data = {
        "DocumentAsBase64String" => base_64_file,
        "DocumentLastModified" => modified_date
        #other options here (see https://sovren.com/technical-specs/latest/rest-api/resume-parser/api/)
      }.to_json
       
      #use https://eu-rest.resumeparsing.com/v10/parser/resume if your account is in the EU data center or
      #use https://au-rest.resumeparsing.com/v10/parser/resume if your account is in the AU data center
       
      uri = "https://eu-rest.resumeparsing.com/v10/parser/resume"
      respObj = send_post_req uri,data
      
      # Access properties such as the GivenName and PlainText
      # user_resume = @user_resume.update parsed_resume: respObj, transaction_id: respObj['Info']['transactionId']
      @user_resume.update transaction_id: respObj['Info']['transactionId']

      create_parsed_json_file respObj
      # AccountBlock::UserParsedResume.create(user_resume_id: @user_resume.id, account_id: user_id, parsed_resume: respObj)

      create_preferred_skills respObj  #store skills

      create_index_for_resume respObj
      
      # make_indexing respObj # for resume indexing need to remove

      x = ui_matching @user_resume # UI matching

      if x
        OpenStruct.new(success?: true)
      else
        OpenStruct.new(success?: false)
      end
      # puts "{ key: #{respObj} }"

      # render json: { key: respObj }
      # givenName = respObj["Value"]["ResumeData"]["ContactInformation"]["CandidateName"]["GivenName"]
      # resumeText = respObj["Value"]["ResumeData"]["ResumeMetadata"]["PlainText"]
    end

    # To Parse JD -> send JD to sovren
    def self.jd_parser params, current_user, client_jd,identifier
      return update_role(params, client_jd) if params[:jd_file] == "undefined"
      file_path = params[:jd_file]
      file_data = IO.binread(file_path)
      modified_date = File.mtime(file_path).to_s[0,10]
      base_64_file = Base64.encode64(file_data)
      identifier = identifier

      data = JSON.dump({
        "DocumentAsBase64String": base_64_file,
        "DocumentLastModified": modified_date,
        "IndexingOptions": {
          "IndexId": "jd001",
          "DocumentId": identifier, #an unique identifier to generate documentID
         }
      })
      uri = URI.parse("https://eu-rest.resumeparsing.com/v10/parser/joborder")
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
      create_job_description params, current_user, respObj, client_jd, identifier
    end

    private

    def self.update_role(params, client_jd)
      client_jd.role.update!(params.except(:jd_file))
      return OpenStruct.new(success?: true, obj: client_jd)
    rescue Exception => e
      return OpenStruct.new(success?: false, errors: e)
    end

    def self.create_job_description params, current_user, data, client_jd, identifier
      jd = data['Value']['JobData']
      if jd.present?
        job_des = nil
        begin
  
          ActiveRecord::Base.transaction(isolation: :serializable) do
            # if section is used when client try to update the automate job description.
            if client_jd.present?
              role = client_jd.role.update!(params.except(:jd_file))
              exp = find_or_create_exp(jd)
              client_jd.update!(preferred_overall_experience_id: exp.id, parsed_jd: data['Value'], job_title: jd['JobTitles'].present? ? jd['JobTitles']['MainJobTitle'] : nil,
                parsed_jd_transaction_id: data['Info']['TransactionId'], location: jd['CurrentLocation'].present? ? jd['CurrentLocation']['Municipality'] : nil,
                jd_file: params[:jd_file]
              )
              # url_generation current_user, client_jd.try(:id) # UI generation for JD TO RESUME
              return OpenStruct.new(success?: true, obj: client_jd)
            else
              if !params["is_closed"] && params["position"].to_i > 0
                role = BxBlockRolesPermissions::Role.new(params.except(:jd_file, :identifier))
                role.account_id = current_user.id
                return OpenStruct.new(success?: false, errors: role.errors ) unless role.save!
              else
                return OpenStruct.new(success?: false, errors: "wrong parameters.")
              end
            end
            
            exp = find_or_create_exp(jd)
            salary =  jd['JobMetadata']['PlainText'].match(/SALARY:\r\n.*/).to_s.gsub("SALARY:",'').squish.to_s           
            job_des = BxBlockJobDescription::JobDescription.create!(preferred_overall_experience_id: exp.id, parsed_jd: data['Value'], jd_type: 'automatic', 
              parsed_jd_transaction_id: data['Info']['TransactionId'], role_id: role.id, job_title: jd['JobTitles'].present? ? jd['JobTitles']['MainJobTitle'] : nil,
              location: jd['CurrentLocation'].present? ? jd['CurrentLocation']['Municipality'] : nil, minimum_salary: salary, jd_file: params[:jd_file])

            # create_index_for_jd data, current_user, job_des.try(:document_id) # Indexing for JD along with document ID
            sovren_score_jd_to_resumes data, job_des.try(:id)
            job_des.update(document_id: identifier)
            job_des = url_generation current_user, job_des, identifier # UI generation for JD TO RESUME
            return OpenStruct.new(success?: true, obj: job_des)
          end
          
        rescue Exception => e
          return OpenStruct.new(success?: false, errors: e)
        end
      else
        return OpenStruct.new(success?: false, errors: data['Value']['ParsingResponse']['Message'])
      end
    end

    def self.find_or_create_exp(jd)
      min_year = jd.dig("MinimumYears", "Value") || 0
      max_year = jd.dig("MaximumYears", "Value") || 0
      experiences_year = if min_year.zero? && max_year.zero?
                          0
                        elsif min_year.zero? && !max_year.zero?
                          max_year
                        elsif !min_year.zero? && max_year.zero?
                          min_year
                        else
                          "#{min_year}-#{max_year}"
                        end

      exp = BxBlockPreferredOverallExperiences::PreferredOverallExperiences.find_or_create_by(
        minimum_experience: min_year,
        maximum_experience: max_year,
        experiences_year: experiences_year,
        level: nil,
        grade: nil)
      exp
    end

    def create_preferred_skills obj
      user.user_preferred_skills.destroy_all if user.user_preferred_skills.present?

      if obj['Value'].present?
        if obj['Value']['ResumeData'].present?
          if obj['Value']['ResumeData']['SkillsData'].present?
            obj['Value']['ResumeData']['SkillsData'].each do |skill_data|
              if skill_data['Taxonomies'].present?
                skill_data['Taxonomies'].each do |taxno|
                  if taxno['SubTaxonomies'].present?
                    taxno['SubTaxonomies'].each do |sub_taxno|
                      if sub_taxno['Skills'].present?
                        sub_taxno['Skills'].each do |skill|
                          if skill['Variations'].present?
                            skill['Variations'].each do |var|
                              if var['FoundIn'].present?
                                var['FoundIn'].each do |found|
                                  if found['SectionType'].present? && (found['SectionType'] == "SKILLS")
                                    pre_skill = BxBlockPreferredRole::PreferredSkill.find_or_initialize_by(name: skill['Name'])
                                    if pre_skill.save!
                                      user_ps = user.user_preferred_skills.find_or_initialize_by(preferred_skill_id: pre_skill.id)
                                      user_ps.save!
                                    end
                                  end
                                end
                              end
                            end
                          else
                            skill['FoundIn'].each do |found|
                              if found['SectionType'].present? && (found['SectionType'] == "SKILLS")
                                pre_skill = BxBlockPreferredRole::PreferredSkill.find_or_initialize_by(name: skill['Name'])
                                if pre_skill.save!
                                  user_ps = user.user_preferred_skills.find_or_initialize_by(preferred_skill_id: pre_skill.id)
                                  user_ps.save!
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    # UI matching for sovren score -> temporary added to check score
    def ui_matching user_resume
      # ======================================================================================
      # For Fetch a score from sovren
      # ======================================================================================
      doc_id = "#{@user_resume.document_id}".downcase&.gsub(' ', '_')
      uri = "https://eu-rest.resumeparsing.com/v10/matcher/indexes/1/documents/#{doc_id}"
      data =  { "IndexIdsToSearchInto" => [ "jd001" ] }.to_json
      score_rs = send_post_req uri,data
      # TO STORE A SOVREN SCORE IN THE TABLE
      if score_rs.present?
        if score_rs["Value"]["Matches"].present?
          user_resume.update(sovren_score: score_rs["Value"]["Matches"].first["SovScore"])
        else
          user_resume.update(sovren_score: 0)
        end
      end
    end

    # retrive multiple resumes against a JD for soveren score
    def self.sovren_score_jd_to_resumes data, jd_id
      url = "https://eu-rest.resumeparsing.com/v10/matcher/joborder"
      data =  { "UIOptions" =>  { "Username" =>  "namita.akhauri@xcelyst.com", "ShowBanner" => true, "SovScoreName" => "Xcelyst" }, "JobData" => data['Value']['JobData'], "IndexIdsToSearchInto" => [ "resume_index", "1", "bulk_uplod_index"] }.to_json
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
      if  respObj['Value']["Matches"].present?
        respObj['Value']["Matches"].each do |a|
          user = AccountBlock::UserResume.find_by(document_id: a["Id"])
          user.update(sovren_score: a["WeightedScore"]) if user.present? 
        end
      end
    end  
    

    # UI generation for Job ORDER
    # ForamThakral_12/04/2022 
    def self.url_generation current_user, job_des, identifier
      # ==========================================================================================
      # TO GENERATE URL FOR UI PURPOSE
      # ==========================================================================================
      # "UIOptions" =>  { "Username" =>  "namita.akhauri@xcelyst.com", "ShowBanner" => true, "SovScoreName" => "Xcelyst" }
      data =  { "UIOptions" =>  { "Username" =>  "namita.akhauri@xcelyst.com", "ShowBanner" => true, "SovScoreName" => "XcelystScore" }, "SaasRequest" => {"IndexIdsToSearchInto" => ["1", "resume_index", "bulk_uplod_index"] }, "ParseOptions" => {}, "GeocodeOptions"=> {} }.to_json

      uri = URI.parse("https://eu-rest.resumeparsing.com/ui/v10/matcher/indexes/jd001/documents/#{identifier}")
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
      sovren_url = JSON.parse(res.body)
      
      # Store URL in JD
      jd_data = BxBlockJobDescription::JobDescription.find_by(id: job_des.id)
      sovren_url.present? ? jd_data.update(sovren_ui_url: sovren_url.fetch("url") ) : jd_data.update(sovren_ui_url: " ")
      jd_data
    end  


    # send_post_request
    # ForamThakral_12/04/2022
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
      respObj = JSON.parse(res.body)
    end  

     # the indexes are same for devlopment, staging and production environment
    def create_index_for_resume parsed_resume
      # NO NEED TO CREATE INDEXES MULTIPLE TIMES -> ONCE INDEXES HAS BEEN CREATED YOU JUST NEED TO ASSIGN TO RESUMES
      # ============================================================================================
      # TO CREATE A INDEX( Creation of Index necessary to assign created index to resume)
      # ============================================================================================
      # uri = "https://eu-rest.resumeparsing.com/v10/index/RESUME_INDEX"
      # data =  { "IndexType" => "Resume" }.to_json
      # respObj = send_post_req uri,data

      # ============================================================================================
      # TO ASSIGN A INDEX TO RESUME ALONG WITH DOCUMENT ID
      # ===========================================================================================
      document_id = @user_resume.document_id.gsub(' ', '_')
      url = "https://eu-rest.resumeparsing.com/v10/index/1/resume/#{document_id}"
      data =  {"ResumeData" =>  parsed_resume["Value"]["ResumeData"] }.to_json
      respObj = send_post_req url,data
    end

    def self.create_index_for_jd data, current_user, jd_id
      # NO NEED TO CREATE INDEXES MULTIPLE TIMES -> ONCE INDEXES HAS BEEN CREATED YOU JUST NEED TO ASSIGN TO JDs
      # # ===========================================================================================
      # # TO CREATE A INDEX( Creation of Index necessary to assign created index to Job Order)
      # # ===========================================================================================
      # data =  { "IndexType" => "Job" }.to_json

      # uri = URI.parse("https://eu-rest.resumeparsing.com/v10/index/001123")
      # https = Net::HTTP.new(uri.host,uri.port)
      # https.use_ssl = true

      # headers = {
      #   'Content-Type' => 'application/json',
      #   'Accept' => 'application/json',
      #   'Sovren-AccountId' => ENV['SOVREN_ID'] || '14044560', # use your account id here
      #   'Sovren-ServiceKey' => ENV['SOVREN_KEY'] || 'qQ8I+UkWFIRC0p9fx0GDq5wDCAw75mgNJERyB+RO', # use your service key here
      # }

      # req = Net::HTTP::Post.new(uri.path, initheader = headers)
      # req.body = data
      # res = https.request(req)
       
      # # Parse the response body into an object
      # respObj = JSON.parse(res.body)

      # ==========================================================================================
      # TO ASSIGN A INDEX TO Job Order ALONG WITH DOCUMENT ID
      # ==========================================================================================
      data =  {"JobData" =>  data }.to_json
      uri = URI.parse("https://eu-rest.resumeparsing.com/v10/index/jd001/joborder/DOCUMENT_#{jd_id}")
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
      respObj = JSON.parse(res.body) if res.present?

    end

    def create_parsed_json_file(file_data)
      begin
        create_directory_if_not_exist
        file_name = "user-resume-#{SecureRandom.hex(20)}.txt"
        file_path = "#{@directory_name}/#{file_name}"
        my_file = File.open("#{file_path}", "w")

        my_file.write "#{file_data}"

        my_file.close

        @user_resume.parse_resume.attach(
          # key: "account/#{@user_resume.account.id}/user_resume/#{file_name}",
          io: File.open("#{file_path}"),
          filename: "#{file_name}",
          content_type: 'application/txt',
          identify: false
        )
        
        File.delete(file_path)

      rescue Exception => e
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join("\n")
      end
    end

    def create_directory_if_not_exist
      @directory_name = "public/user_resume"
      Dir.mkdir(@directory_name) unless File.exists?(@directory_name)
    end

  end
end