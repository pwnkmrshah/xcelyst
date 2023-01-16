module BxBlockBulkUpload
  class DatabaseUser
    class << self

      # create by akash deep
      # this method is used to save the json file records into database.
      # all the records should be differentiate by the uid field which is unique and any uid present already
      # in the db. It will update that record.
      def save_database_user file
        @count = 0
        @uid_arr = []
        @errors = []
        # file_path = file
        # file_data = IO.binread(file_path)
        # user_data = JSON.parse(file_data)  # parse the json data file to convert into proper json.
        
        s3 = Aws::S3::Client.new
        resp = s3.get_object(bucket: ENV["AWS_BUCKET"], key: file)
        user_data = JSON.parse(resp.body.read)
        
        user_data.each do |data|

          data.extend(Hashie::Extensions::DeepLocate)  # use Hashie gem library to deep locate the specific value

          x = data.deep_locate -> (key, value, object) { value.is_a?(String) && value.include?("\u0000") } # check the json contains the string null byte or not

          @uid_arr << data['id'] if x.present?
         
          next if x.present? # if data contains the string null byte then it won't be save into the db.

          # data = traverse(data)

          record = BxBlockDatabase::TemporaryUserDatabase.find_by(uid: data['id'])
          puts record&.id
          if record.present?
            exp = calculate_experience(data['experience'], data['experienceYears']) # calculate the overall experience
            # exp_month = experience_month(exp) # calculate the overall experience into months.
            education = user_degree(data['education'])
            city = user_city(data['locations'], data['experience'])
            company = user_current_company(data['experience'])
            prev_work = user_prev_exp(data['experience'])
            certificates = user_certification(data['certification'])
            projects = user_projects(data['project'])
            courses = user_courses(data['course'])
            begin
              user_rec = record.update(full_name: data['fullName'], photo_url: data['photo'],
                position: data['experience'], location: data['locations'], contacts: data['contacts'], social_url: data['social'],
                skills: data['skills'], name: data['fullName'], summary: data['summary'], title: nil, zipcode: nil, city: city, ready_to_move: false, experience: exp,
                company: company, previous_work: prev_work, degree: education, job_projects: projects, lead_lists: nil)
            
              if user_rec
                @count += 1

                puts @count

                if record.temporary_user_profile.present?
                  record.temporary_user_profile.update(head_line: data['headLine'], languages: data['language'], organizations: data['organization'],
                    skills: data['skills'], education: data['education'], work_experience: data['experience'], courses: courses, certificates: certificates)
                end
              end
            rescue => exception
              @errors << {id: data['id'], errors: exception}
            end

          else
            create_temp_user_db_record data
          end

        end

        s3.delete_object(bucket: ENV["AWS_BUCKET"], key: file)
        # File.delete(file_path)

        return OpenStruct.new(count: @count, uid_arr: @uid_arr, errors: @errors)
        
      end

      private
      def user_courses(courses)
        return if courses.blank?
        courses.map{ |course| course['name'] }
      end

      def user_projects(projects)
        return if projects.blank?
        projects.map{|project| project['name']}.join(', ')
      end

      def user_degree(education)
        return if education.blank?
        education.map{|edu| [edu['university'], edu['degree'].join()] }.join(', ')
      end

      def user_certification(certification)
        return if certification.blank?
        certification.map{|certificate| certificate['name'] }
      end

      def user_prev_exp(exp)
        return if exp.blank?
        exp.map{|ex| [ex['company'], ex['position']] }
      end

      def user_current_company(experience)
        return if experience.blank?
        current_experience(experience).first['company']
      end

      def user_city(location, experience)
        if location.present?
          location.join().split(',').first
        elsif experience.present?
          current_experience(experience).first['location'] if current_experience(experience).present?
        end
      end

      def current_experience(experience)
        experience.select{|a| a[:current] == true || a['current'] == true }
      end

      def traverse(data)
        data.dup.transform_values do |v|
          next traverse(v) if v.is_a?(Hash)
          (v.is_a?(String) && v.include?("\u0000")) ? v.delete("\u0000") : v
        end
      end

      # created by akash deep
      # create record into the db.
      def create_temp_user_db_record data
        exp = calculate_experience(data['experience'], data['experienceYears']) # calculate the overall experience
        # exp_month = experience_month(exp)
        education = user_degree(data['education'])
        city = user_city(data['locations'], data['experience'])
        company = user_current_company(data['experience'])
        prev_work = user_prev_exp(data['experience'])
        certificates = user_certification(data['certification'])
        projects = user_projects(data['project'])
        courses = user_courses(data['course'])

        begin
          user_rec = BxBlockDatabase::TemporaryUserDatabase.new(uid: data['id'], full_name: data['fullName'], photo_url: data['photo'],
            position: data['experience'], location: data['locations'], contacts: data['contacts'], social_url: data['social'],
            skills: data['skills'], name: data['fullName'], summary: data['summary'], title: nil, zipcode: nil, city: city, ready_to_move: false, experience: exp,
            company: company, previous_work: prev_work, degree: education, job_projects: projects, lead_lists: nil)

          if user_rec.save

            @count += 1

            user_rec.create_temporary_user_profile(head_line: data['headLine'], languages: data['language'], organizations: data['organization'],
              skills: data['skills'], education: data['education'], work_experience: data['experience'], courses: courses.split, certificates: certificates.split)
          end
        rescue => exception
          @errors << {id: data['id'], errors: exception}
        end
      end

      # created by akash deep
      # calculate the overall exp into months
      # def experience_month(exp)
      #   exper = exp.split
      #   months = 0
      #   if exper.find_index("years").present?
      #     months = exper[exper.find_index("years") - 1].to_i * 12
      #   end
      #   if exper.find_index("months").present?
      #     month = exper[exper.find_index("months") - 1].to_i + months
      #   end
      #   months
      # end


      # created by akash deep
      # calculate overall exp into string format ( for e.g., 4 years 3 months 10 days)
      def calculate_experience(experience, experience_years)
        return "#{experience_years} years" if experience_years.present?
        if experience.present?
          @total_days = 0
          experience.each do |exp|
            if exp['current']
              if exp['started'].present?
                @total_days += (Date.today - exp['started'].to_date).to_i
              end
            else
              @total_days += (exp['ended'].to_date - exp['started'].to_date).to_i if exp['started'].present? && exp['ended'].present?
            end
          end
          x = total_experience_conversion
          if x.success?
            "#{(x.years.present? && x.years > 0) ? "#{x.years} #{(x.years > 1) ? 'years' : 'year'}" : nil } #{(x.months.present? && x.months > 0) ? "#{x.months} #{x.months > 1 ? 'months' : 'month'}" : nil }"
          else 
            'NA'
          end
        else
          'NA'
        end
      end

      def total_experience_conversion
        if @total_days > 0
          years = get_years
          months = get_months
          OpenStruct.new(success?: true, years: years, months: months)
        else
          OpenStruct.new(success?: false)
        end
      end

      def get_years
        if @total_days > 365
          total_months = (@total_days/30.4)
          @years = (total_months/12).floor
        end 
      end

      def get_months
        if @total_days > 30
          if @years.present?
            total_months = (@total_days/30.4)
            @months = (total_months%12).floor
          else
            @months = (@total_days/30.4).floor
          end
        end
      end

      # def get_days
      #   if @total_days > 0
      #     if @months.present?
      #       @days = (@total_days%30).floor
      #     else
      #       @days = @total_days.floor
      #     end
      #   end
      # end
    end
  end
end


