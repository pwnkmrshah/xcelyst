ActiveAdmin.register AccountBlock::TemporaryAccount, as: "Temporary Account" do
	menu parent: "Bulk Upload", label: "Temporary Account"
	
	actions :index, :destroy

	filter :email
	filter :document_id
	filter :phone_no

	index do
		form do |f|
			div class: "align-dropdown" do
			  div do
				f.label do
				  "Text Message"
				end
				f.textarea class: "text_message_whasapp"
			  end
			  div do
				f.button class: "button", id: "send_message_aj" do
				  "send message"
				end
			  end
			end
		end
		selectable_column
		id_column
		column :first_name
		column :last_name
		column :email
		column :phone_no
		# column :current_city do |obj|
		# 	data = []
		# 	# parsed_resume = obj.parsed_resume.present? ? obj.parsed_resume : obj.get_parsed_resume_data
		# 	parsed_resume = obj.get_parsed_resume_data
		# 	if parsed_resume.present?
		# 		if parsed_resume['Value'].present?
	    #         	if parsed_resume['Value']['ResumeData'].present?
	    #         		if parsed_resume['Value']['ResumeData']['ContactInformation'].present?
	    #         			if parsed_resume['Value']['ResumeData']['ContactInformation']['Location'].present?
	    #         				if parsed_resume['Value']['ResumeData']['ContactInformation']['Location']['Municipality'].present?
	    #         					data << parsed_resume['Value']['ResumeData']['ContactInformation']['Location']['Municipality']
	    #         				end
	    #         			end
	    #         		end
	    #         	end
	    #         end
	    #     end
        #     data
		# end
		column :resume do |obj|
    	if obj.resume_file.present?
      	a class: 'button', target: '_blank', href: url_for(obj.resume_file), download: '' do 
        	"Download File"
      	end
    	end
  	end
		column :actions do |item|
			links = []
			links << link_to("Permanent", make_permanent_account_admin_temporary_account_path(item), method: :put, class: "button", style: "font-size: 15px;margin: 1px")
      links << link_to("Temporary By Admin", temporary_make_permanent_account_admin_temporary_account_path(item), method: :put, class: "button", style: "font-size: 15px;margin: 1px")
    	links << link_to('Delete', admin_temporary_account_path(item), method: :delete, confirm: 'Are you sure?', class: "button", style: "font-size: 15px;margin: 1px")
    	links.join(' ').html_safe
  	end 
	end


	member_action :make_permanent_account, method: :put do
    x = resource.permanent!
    if x.success?
    	redirect_to admin_temporary_accounts_path, notice: "Moved to Normal Account!"
    else
    	flash[:error] = "This record has incomplete fields."
    	redirect_to admin_temporary_accounts_path
    end
  end

  member_action :temporary_make_permanent_account, method: :put do
    x = resource.permanent_by_admin!
    if x.success?
      redirect_to admin_temporary_accounts_path, notice: "Moved to Normal Account!"
    else
		if x.errors == "Account Already present with this email."
			flash[:error] = "Account Already present with this email."
		else
			flash[:error] = "This record has incomplete fields."
		end
      redirect_to admin_temporary_accounts_path
    end
  end
	
	action_item :only => :index do
	    link_to 'Upload Bulk Resume', { :action => 'upload_resume_file' }, :class => 'upload-hide'
	end

	collection_action :upload_resume_file do
  	render "/admin/upload_resume_file"
	end

  collection_action :import_bulk_resume, :method => :post do
    if params[:upload_resume_file] && params[:upload_resume_file][:file]
   	# -------------------------------------------------- background job flow start from here ---------------------------------------------------

		  		# dir = Rails.root.join('public', 'uploads')
				# 	Dir.mkdir(dir) unless Dir.exist?(dir)
				# 	file_names = []
				# 	params[:upload_resume_file][:file].each do |file|
				# 		uploaded_io = file
				# 		file_names.push(uploaded_io.original_filename)
				# 		File.open(dir.join(uploaded_io.original_filename), 'wb') do |f|
				# 		  f.write(uploaded_io.read)
				# 		end
				# 	end
				file_names = []
				params[:upload_resume_file][:file].each do |file|
					file_names.push(file.original_filename)
					s3_client = Aws::S3::Client.new(region: ENV["AWS_REGION"])
					bucket_name = ENV["AWS_BUCKET"]
					object_key = file.original_filename
					response = s3_client.put_object(
						bucket: bucket_name,
						key: object_key,
						body: file
					)
				end
		  		BxBlockBulkUpload::ResumeUploadJob.set(wait: 5.seconds).perform_later(file_names)
		   		redirect_to admin_temporary_accounts_path, flash: {:notice => "Resume process will start on backend soon."}
   	# -------------------------------------------------- background job flow end here ---------------------------------------------------

    # -------------------------------------------------- normal flow start from here ---------------------------------------------------


  		# if params[:upload_resume_file][:file].content_type.include?("application/pdf")
      	# x = BxBlockBulkUpload::ResumeUpload.execute(params[:upload_resume_file][:file])
      	# if x.count > 0
        # 		redirect_to admin_temporary_accounts_path, flash: {:notice => "#{x.count} resume uploaded successfully"}
      	# else
        # 		redirect_to upload_resume_file_admin_temporary_accounts_path, flash: { error: "There is some problem with Resume File. Please check sample file and upload again!" }
      	# end
    	# else
     # 		redirect_to upload_resume_file_admin_temporary_accounts_path, flash: { error: "File format not valid!" }
    	# end

    # ---------------------------------------------------normal flow end here---------------------------------------------------
    else
      redirect_to upload_resume_file_admin_temporary_accounts_path, flash: { error: "Please select file!" }
    end
	end

	controller do
		def scoped_collection
      	  AccountBlock::TemporaryAccount.where(is_permanent: false)
    	end

	end


end   