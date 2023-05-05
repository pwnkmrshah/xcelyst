require 'open-uri'
module AccountBlock
	class TemporaryAccount < ApplicationRecord
		self.table_name = :temporary_accounts

		has_one_attached :resume_file, dependent: :destroy
    has_one_attached :parse_resume, dependent: :destroy

    has_many :send_messages, -> { where(sender_type: "AccountBlock::TemporaryAccount") }, as: :sender, class_name: "BxBlockWhatsapp::WhatsappMessage", dependent: :destroy
    has_many :receive_messages, -> { where(receiver_type: "AccountBlock::TemporaryAccount") }, as: :receiver, class_name: "BxBlockWhatsapp::WhatsappMessage", dependent: :destroy
    has_many :whatsapp_chats, -> {where(user_type: "AccountBlock::TemporaryAccount")}, as: :user, foreign_key: "user_id" ,class_name: "BxBlockWhatsapp::WhatsappChat", dependent: :destroy

		def permanent!
			x = create_account_record
			if x.success?
				update(is_permanent: true)
				return OpenStruct.new(success?: true)
			else
				return OpenStruct.new(success?: false, errors: x.errors)
			end
		end

    def permanent_by_admin!
      x = create_account_record_by_admin
      if x.success?
        update(is_permanent: true)
        return OpenStruct.new(success?: true)
      else
        return OpenStruct.new(success?: false, errors: x.errors)
      end
    end

    def get_parsed_resume_data 
      if self.parse_resume.present?
        if self.parse_resume.attached?
          data = [
            Thread.new {
              url = Rails.application.routes.url_helpers.rails_blob_url(self.parse_resume)
              result = open(url).read
              eval(result)
            }
          ].map(&:value)
          data[0]
        end  
      end  
    end

		private

		def create_account_record
			query_email = email.downcase
    	account = EmailAccount.where("LOWER(email) = ?", query_email).first
    	if account.present?
    		return OpenStruct.new(success?: false, errors: "Account Already present with this email.")
    	else
    		begin
          ActiveRecord::Base.transaction(isolation: :serializable) do

            @account = EmailAccount.new(self.attributes.slice(*whitelisted_fields).merge!(user_role: 'candidate',is_converted_account: true))

            # parsed_resume = self.parsed_resume.present? ? self.parsed_resume : get_parsed_resume_data

            parsed_resume = get_parsed_resume_data

            # parsed_resume = self.parsed_resume.present? ? self.parsed_resume : TempAccount.find_by(temporary_account_id: self.id).parsed_resume

            if parsed_resume.present?
              if parsed_resume['Value'].present?
              	if parsed_resume['Value']['ResumeData'].present?
              		if parsed_resume['Value']['ResumeData']['ContactInformation'].present?
              			if parsed_resume['Value']['ResumeData']['ContactInformation']['Location'].present?
              				if parsed_resume['Value']['ResumeData']['ContactInformation']['Location']['Municipality'].present?
              					@account.current_city = parsed_resume['Value']['ResumeData']['ContactInformation']['Location']['Municipality']
              				end
              			end
              		end
              	end
              end
            end

            @account.password = "12345678"
            @account.password_confirmation = "12345678"
            @account.phone_number = self.phone_no

            # if @account.current_city.blank?
            # 	@account.current_city = Faker::Address.country 
            # end

            # if @account.first_name.blank?
            # 	@account.first_name = Faker::Name.first_name
            # end

            # if @account.last_name.blank?
            # 	@account.last_name = Faker::Name.last_name
            # end

            # if @account.email.blank?
            # 	email = "#{@account.first_name.gsub(' ','')}@yopmail.com".downcase!
            # 	record = EmailAccount.where("LOWER(email) = ?", email).first
            # 	if record.present?
            # 		usernames = find_unique_username(@account.first_name.gsub(' ',''))
            # 		usernames.each do |username|
            # 			email = "#{username}@yopmail.com".downcase!
            # 			record = EmailAccount.where("LOWER(email) = ?", email).first
            # 			unless record.present?
            # 				@account.email = email
            # 				break
            # 			end
            # 		end
            # 	end
            # end

            # if @account.password.blank?
            # 	pass = @account.first_name.gsub(' ','').capitalize
            # 	if pass.present?
            # 		@account.password = pass 
            # 		@account.password_confirmation = pass 
            # 	else
            # 		@account.password = "12345678"
            # 		@account.password_confirmation = "12345678"
            # 	end
            # end

            # if @account.phone_number.blank?
            #   @account.phone_number = Faker::PhoneNumber.cell_phone_in_e164
            # end

            attach_file

            if @account.save!
              profile = BxBlockProfile::Profile.new(account_id: @account.id)
              if profile.save!
              	return OpenStruct.new(success?: true)
                
                # BxBlockSovren::Sovren.new(params[:resume], @account).execute
                # update_index_and_doc_id(@account.parsed_resume, @user_resume)
              end
            end
          end
        rescue Exception => e
        	return OpenStruct.new(success?: false, errors: e)
        end

    	end
		end

    def create_account_record_by_admin
      new_email = email.split("@")[0]
      new_email = "#{new_email}@yopmail.com"

      query_email = new_email.downcase
      account = EmailAccount.where("LOWER(email) = ?", query_email).first
      if account.present?
        return OpenStruct.new(success?: false, errors: "Account Already present with this email.")
      else
        begin
          ActiveRecord::Base.transaction(isolation: :serializable) do
            self.email = new_email
            @account = EmailAccount.new(self.attributes.slice(*whitelisted_fields).merge!(user_role: 'candidate',is_converted_account: true))

            # parsed_resume = self.parsed_resume.present? ? self.parsed_resume : get_parsed_resume_data

            parsed_resume = get_parsed_resume_data

            # parsed_resume = self.parsed_resume.present? ? self.parsed_resume : TempAccount.find_by(temporary_account_id: self.id).parsed_resume

            if parsed_resume.present?
              if parsed_resume['Value'].present?
                if parsed_resume['Value']['ResumeData'].present?
                  if parsed_resume['Value']['ResumeData']['ContactInformation'].present?
                    if parsed_resume['Value']['ResumeData']['ContactInformation']['Location'].present?
                      if parsed_resume['Value']['ResumeData']['ContactInformation']['Location']['Municipality'].present?
                        @account.current_city = parsed_resume['Value']['ResumeData']['ContactInformation']['Location']['Municipality']
                      end
                    end
                  end
                end
              end
            end

            @account.password = "12345678"
            @account.password_confirmation = "12345678"
            @account.phone_number = "+91#{rand(10 ** 10)}"
            @account.activated = true # by default activate this kind of accounts
            attach_file

            if @account.save!
              profile = BxBlockProfile::Profile.new(account_id: @account.id)
              if profile.save!
                return OpenStruct.new(success?: true)

                # BxBlockSovren::Sovren.new(params[:resume], @account).execute
                # update_index_and_doc_id(@account.parsed_resume, @user_resume)
              end
            end
          end
        rescue Exception => e
          return OpenStruct.new(success?: false, errors: e)
        end

      end
    end

		def whitelisted_fields
			fields = %w[email first_name last_name]
		end

		def attach_file
      file = resume_file
      @account.resume_image.attach \
        :io           => StringIO.new(file.download),
        :filename     => file.filename,
        :content_type => file.content_type
    end

    def find_unique_username(username)
      taken_usernames = EmailAccount
        .where("email LIKE ?", "#{username}%")
        .pluck(:email)

      username_arr = []

      username_arr << username if ! taken_usernames.include?(username)

      digit = []
      taken_usernames.map do |name|
        val = name.split('_').last.to_i
        digit << val
      end

      count = 2
      temp = 0
      while true
        new_username = "#{username}_#{count}"
        break username_arr << new_username if ! taken_usernames.include?(new_username)
        count += 1
      end

      if digit.count < 100
        while true
          new_username = "#{username}_#{rand.to_s[2..3]}"
          username_arr << new_username if ! taken_usernames.include?(new_username)
          temp +=1
          break if temp == 2
        end
      end

      if digit.count > 100 && digit.count < 1000
        while true
          new_username = "#{username}_#{rand.to_s[2..4]}"
          username_arr << new_username if ! taken_usernames.include?(new_username)
          temp +=1
          break if temp == 4
        end
      end

      while true
        a = ['&','@']
        new_username = "#{username.split('_').first}#{a[rand(a.length)]}_#{rand.to_s[2..4]}"
        username_arr << new_username if ! taken_usernames.include?(new_username)
        temp +=1
        break if temp == 5
      end

      username_arr
    end

    def update_index_and_doc_id(parsed_resume, user_resume)
    	url = "https://eu-rest.resumeparsing.com/v10/index/1/resume/#{@user_resume.document_id}"
      data =  {"ResumeData" =>  parsed_resume["Value"]["ResumeData"] }.to_json
      respObj = send_post_req url,data
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
      respObj = JSON.parse(res.body)
    end	

	end
end
