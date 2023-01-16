class ParseFileUpload
	class << self

		# created by akash deep
		def upload_parsed_json_file data, record, type
	      begin
	        create_directory_if_not_exist type
	        file_name = "#{type}-#{SecureRandom.hex(20)}.txt"
	        file_path = "#{@directory_name}/#{file_name}"
	        my_file = File.open("#{file_path}", "w") # create a file in write mode.
 
	        my_file.write "#{data}"  # write all the data into the file.

	        my_file.close

	        # attach the file with the associated record.
	        record.parse_resume.attach(
	          io: File.open("#{file_path}"),
	          filename: "#{file_name}",
	          content_type: 'application/txt',
	          identify: false
	        )
	        
	        File.delete(file_path)  # delete the file thereafter.

	      rescue Exception => e
	        Rails.logger.error e.message
	        Rails.logger.error e.backtrace.join("\n")
	      end
	    end

	    # created by akash deep
	    # check and create the directory if not exist
	    def create_directory_if_not_exist type
	      @directory_name = "public/#{type.gsub('-','_')}"
	      Dir.mkdir(@directory_name) unless File.exists?(@directory_name)
	    end

	end
end