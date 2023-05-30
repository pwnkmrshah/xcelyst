ActiveAdmin.register BxBlockDatabase::TemporaryUserDatabase, as: "Database User" do
	menu parent: "Bulk Upload", label: "Database User"

	actions :index, :destroy, :show

	filter :full_name  

	index do
		selectable_column
		id_column
    column :uid
		column :full_name
		column :current_position do |obj|
    	data = ""
			obj.position&.each do |pos|
				if pos['current'].present? && pos['current']
					data = "#{pos['position']} in #{pos['company']}, #{pos['location']}"
				end
			end
    	data
   		end
		column :email do |obj|
			emails = []
			obj.contacts && obj.contacts.each do |contact|
				if contact['type'] == "email"
					emails << contact['value']
				end
			end
			if emails.first.present?
				emails.first
			else
				"empty"
			end
 	   	end
		column :total_experience do |obj|
			obj.experience
		end
		actions 
	end

	show do
  	attributes_table do
      row :full_name
      row :uid
      row :email do |obj|
      	emails = []
        if obj.contacts.present?
        	obj.contacts.each do |contact|
        		if contact['type'] == "email"
        			emails << contact['value']
        		end
        	end
        end
      	emails
      end
      row :phone_no do |obj|
      	phones = []
        if obj.contacts.present?
        	obj.contacts.each do |contact|
        		if contact['type'] == "phone"
        			phones << contact['value']
        		end
        	end
        end
      	phones
      end
      row :current_position do |obj|
      	data = ""
      	obj.position&.each do |pos|
      		if pos['current'].present? && pos['current']
      			data = "#{pos['position']} in #{pos['company']}, #{pos['location']}"
      		end
      	end
      	data
      end
      row :previous_designation do |obj|
      	designations = []
      	obj.position&.each do |pos|
      		unless pos['current'].present? && pos['current']
      			designations << "#{pos['position']} in (#{pos['company']}, #{pos['location']}) "
      		end
      	end
      	designations
      end
      row :title
      row :zipcode
      row :city
      row :status
      row :ready_to_move
      row :name 
      row :location
      row :experience
      row :courses do |obj|
        obj.temporary_user_profile&.courses
      end
      row :current_company do |obj|
        obj.company
      end
      row :skills
      row :degree 
      row :job_projects
      row :lead_lists
      row :profile_photo do |obj|
      	if obj.photo_url.present?
      		image_tag(obj.photo_url['url'])
      	end
      end
      row :social_url
      row :summary
      row :honor_awards do |obj|
      	obj.temporary_user_profile&.honor_awards
      end
      row :linkedin_url do |obj|
      	obj.temporary_user_profile&.linkedin_url
      end
  	end
	end

	action_item :only => :index do
	  link_to 'Upload JSON', { :action => 'upload_json_file' }, :class => 'upload-hide-button'  if current_user_admin.upload_json_file?(current_user_admin)
	end

  collection_action :upload_json_file do
    render "/admin/upload_json_file"
  end

  collection_action :import_json, :method => :post do
    if params[:upload_json_file] && params[:upload_json_file][:file]
    	file = params[:upload_json_file][:file]
    # -------------------------------------------------- background job flow start from here ---------------------------------------------------

	if file.content_type.include?("text/plain")
		# dir = Rails.root.join('public', 'uploads')
	  #   Dir.mkdir(dir) unless Dir.exist?(dir)
	  #   file_name = file.original_filename
		# File.open(dir.join(file.original_filename), 'wb') do |f|
		#   f.write(file.read)
		# end
	  s3_client = Aws::S3::Client.new(region: ENV["AWS_REGION"])
	  bucket_name = ENV["AWS_BUCKET"]
	  object_key = file.original_filename
	  response = s3_client.put_object(
		  bucket: bucket_name,
		  key: object_key,
		  body: file
	  )
	  if response.etag
		  BxBlockBulkUpload::JsonUploadJob.set(wait: 15.seconds).perform_later(object_key)
		  redirect_to admin_database_users_path, flash: {:notice => "Extracting JSON will start on backend soon."}
	  end
	 else
		 redirect_to upload_json_file_admin_database_users_path, flash: { error: "File format not valid!" }
  	 end


    # -------------------------------------------------- background job flow end here ---------------------------------------------------
      
    # -------------------------------------------------- normal flow start from here ---------------------------------------------------


    #   if file.content_type.include?("text/plain")
    #     x = BxBlockBulkUpload::DatabaseUser.save_database_user(file)
    #     if x.uid_arr.blank?
    #       if x.count > 0
    #           redirect_to admin_database_users_path, flash: {:notice => "#{x.count} resume uploaded successfully" }
    #       else
    #           redirect_to upload_json_file_admin_database_users_path, flash: { error: "There is some problem with JSON File. Please upload the file again!" }
    #       end
    #     else
    #       flash[:notice] = "#{x.count} resume uploaded successfully."
    #       flash[:alert] = []
    #       flash[:alert] << "Some of the record contains null byte error."
    #       flash[:alert] << "Uids: #{x.uid_arr.join(',')}"
    #       redirect_to admin_database_users_path
    #     end
    #   else
    #     redirect_to upload_json_file_admin_database_users_path, flash: { error: "File format not valid!" }
    #   end
    
    # -------------------------------------------------- normal flow end here ---------------------------------------------------

    else
      redirect_to upload_json_file_admin_database_users_path, flash: { error: "Please select file!" }
    end
	end

end   