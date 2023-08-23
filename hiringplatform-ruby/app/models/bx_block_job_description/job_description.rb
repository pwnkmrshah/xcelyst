module BxBlockJobDescription
  class JobDescription < ApplicationRecord
    self.table_name = :job_descriptions

    attr_accessor :is_manual_jd, :identifier, :skills

    JD_CONSTANT = %w(JOB_TITLE COMPANY LOCATION SUMMARY EDUCATION REQUIRED_EXPERIENCE REQUIRED_SKILLS PREFERRED_SKILLS CERTIFICATIONS 
    LANGUAGES MAJOR_JOB_DUTIES_AND_RESPONSIBILITIES)

    validates_presence_of :job_title, presence: true
    belongs_to :role, class_name: "BxBlockRolesPermissions::Role"
    belongs_to :preferred_overall_experience, class_name: "BxBlockPreferredOverallExperiences::PreferredOverallExperiences"
    has_many :skill_matrices, class_name: "BxBlockSkillMatrice::SkillMatrice", dependent: :destroy
    has_many :domain_sub_categories, through: :skill_matrices, class_name: "BxBlockDomainSubCategory::DomainSubCategory"
    has_many :schedule_interviews, class_name: "BxBlockScheduling::ScheduleInterview", dependent: :destroy
    has_many :shortlisting_candidates, class_name: "BxBlockShortlisting::ShortlistingCandidate", dependent: :destroy
    has_one_attached :jd_file, dependent: :destroy

    validates_presence_of :jd_type, inclusion: { in: %w(automatic manual) }
    validates_presence_of :location, message: "can't be blank"
    validates_presence_of :job_title, message: "can't be blank" 

    scope :automatic_jd, -> { where(jd_type: 'automatic') }
    scope :manual_jd, -> { where(jd_type: 'manual') }

    after_initialize :set_default_value

    after_save :manual_jd_file_creation

    private

    def set_default_value
      self.jd_type = 'manual' if self.jd_type.nil?
    end

    def manual_jd_file_creation
      if self.jd_type == 'manual' && self.is_manual_jd
        create_directory_if_not_exist?

        file_name = "#{SecureRandom.hex(20)}.txt"
        file_path = "public/assets/manual_jd/#{file_name}"
        my_file = File.open("#{file_path}", "w")

        JD_CONSTANT.each do |key|
          if key.include?('_')
            key = key.tr('_',' ') 
          end

          case key
          when "JOB TITLE"
            my_file.write "#{key}:#{$/}"
            my_file.write "#{self.job_title} #{$/}"
          when "COMPANY"
            my_file.write "#{key}:#{$/}"
            my_file.write "#{self.company_description} #{$/}"
          when "LOCATION"
            my_file.write "#{key}:#{$/}"
            my_file.write "#{self.location} #{$/}"
          when "SUMMARY"
            my_file.write "#{key}:#{$/}"
            my_file.write "#{$/}"
          when "EDUCATION"
            my_file.write "#{key}:#{$/}"
            my_file.write "#{self.degree} #{$/}"
          when "REQUIRED EXPERIENCE"
            my_file.write "#{key}:#{$/}"
            my_file.write "#{$/}"
          when "REQUIRED SKILLS"
            my_file.write "#{key}:#{$/}"
            create_required_skills my_file
          when "PREFERRED SKILLS"
            my_file.write "#{key}:#{$/}"
            my_file.write "#{$/}"
          when "CERTIFICATIONS"
            my_file.write "#{key}:#{$/}"
            my_file.write "#{$/}"
          when "LANGUAGES"
            my_file.write "#{key}:#{$/}"
            my_file.write "#{$/}"
          when "MAJOR JOB DUTIES AND RESPONSIBILITIES"
            my_file.write "#{key}:#{$/}"
            my_file.write "#{self.job_responsibility}"
          end
        end

        my_file.close

        self.is_manual_jd = false

        self.jd_file.attach(
          io: File.open("#{file_path}"),
          filename: "#{file_name}",
          content_type: 'application/txt',
          identify: false
        )

        jd_parser file_path
      end
    end

    def create_directory_if_not_exist?
      directory_name = "public/assets/manual_jd"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
    end

    def create_required_skills my_file
      if self.skills.present?
        self.skills.each do |ids|
          if ids[0].present?
            sub_cat_name = BxBlockDomainSubCategory::DomainSubCategory.find_by(id: ids[0]).name
            if ids[1].present? && sub_cat_name.present?
              pre_skill_level = BxBlockPreferredOverallExperiences::PreferredSkillLevel.find_by(id: ids[1].first)
              if pre_skill_level.experiences_year.to_i <= 1  
                my_file.write "Candidate atleast have basic knowledge of #{sub_cat_name}. #{$/}"
              elsif pre_skill_level.experiences_year.to_i > 1 && pre_skill_level.experiences_year.to_i <= 3
                my_file.write "Candidate must have Strong knowledge of #{sub_cat_name}. #{$/}"
              elsif pre_skill_level.experiences_year.to_i > 3 && pre_skill_level.experiences_year.to_i <= 6
                my_file.write "Candidate must have Advance knowledge of #{sub_cat_name} and management quality as well. #{$/}"
              end
            end
          else
            my_file.write "#{sub_cat_name} #{$/}"
          end
        end
      end
    end

    def jd_parser file_path
      file_data = IO.binread(file_path)
      modified_date = File.mtime(file_path).to_s[0,10]
       
      base_64_file = Base64.encode64(file_data)

      url = URI("https://eu-rest.resumeparsing.com/v10/parser/joborder")

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Sovren-AccountId' => ENV['SOVREN_ID'] || '14044560', # use your account id here
        'Sovren-ServiceKey' => ENV['SOVREN_KEY'] || 'qQ8I+UkWFIRC0p9fx0GDq5wDCAw75mgNJERyB+RO', # use your service key here
      }

      request = Net::HTTP::Post.new(url, initheader = headers)

      request.body = JSON.dump({
        "DocumentAsBase64String": base_64_file,
        "DocumentLastModified": modified_date,
        "IndexingOptions": {
          "IndexId": "jd001",
          "DocumentId": self.id
         }
      })

      response = https.request(request)
      data = JSON.parse(response.body)

      update_job_description data

      File.delete(file_path) if File.exist?(file_path)
      
      update_sovren_url
    end

    def update_job_description data
      self.update(parsed_jd: data['Value'], parsed_jd_transaction_id: data['Info']['TransactionId'], document_id: self.id)
    end

    def update_sovren_url
      data =  { "UIOptions" =>  { "Username" =>  "namita.akhauri@xcelyst.com", "ShowBanner" => true, "SovScoreName" => "XcelystScore" }, "SaasRequest" => {"IndexIdsToSearchInto" => ["1", "resume_index", "bulk_uplod_index"] }, "ParseOptions" => {}, "GeocodeOptions"=> {} }.to_json

      uri = URI.parse("https://eu-rest.resumeparsing.com/ui/v10/matcher/indexes/jd001/documents/#{self.id}")
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
      (sovren_url.present?) ? self.update(sovren_ui_url: sovren_url.fetch("url") ) : self.update(sovren_ui_url: " ")
    end  


  end
end
