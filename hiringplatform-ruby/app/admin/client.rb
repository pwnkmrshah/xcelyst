ActiveAdmin.register AccountBlock::Account, as: "Client" do
	menu parent: ["Platform Users",  "Client"], label: "Client", if: proc { current_admin_user.present? && current_admin_user.can_read_account_block_for_client?(current_admin_user) }
	
	permit_params :id, :email, :first_name, :last_name, :password, :password_confirmation, :current_city, :user_role, :reset_password_token, :activated

	index do
		selectable_column
		id_column
		column :first_name
		column :last_name
		column :email
		column :created_at
		actions
	end

	action_item :add, only: :show do
		link_to 'Reset Password', change_password_account_block_accounts_path(id: params[:id])
	end

	form do |f|
		f.inputs do
			f.input :first_name
			f.input :last_name
			f.input :current_city
			f.input :email
		end
		f.actions
	end


	filter :email
	filter :first_name
	filter :last_name
	
	show do
		attributes_table do
			row :first_name
			row :last_name
			row :email
			row :current_city
		end 
	end

	# action_item :only => :index do
	#     link_to 'Upload Bulk Resume', :action => 'upload_resume_file', input_html: {  multiple: true }
	# end

 #  	collection_action :upload_resume_file do
 #    	render "/admin/upload_resume_file"
 #  	end

 #  	collection_action :import_bulk_resume, :method => :post do
	#     if params[:upload_resume_file] && params[:upload_resume_file][:file]
	#       # if params[:upload_resume_file][:file].content_type.include?("application/pdf")
	#         x = BxBlockBulkUpload::ResumeUpload.execute(params[:upload_resume_file][:file])
	#         if x.count > 0
	#           redirect_to admin_clients_path, flash: {:notice => "#{x.count} resume uploaded successfully"}
	#         else
	#           redirect_to upload_resume_file_admin_clients_path, flash: { error: "There is some problem with Resume File. Please check sample file and upload again!"}
	#         end
	#       else
	#         redirect_to upload_resume_file_admin_clients_path, flash: { error: "File format not valid!" }
	#       end
	#     # else
	#       # redirect_to upload_resume_file_admin_clients_path, flash: { error: "Please select file!" }
	#     # end
	# end

	controller  do
		before_create :send_email

		def send_email resource
			chars = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a + ['!', '@', '#', '$', '&', '*']
			pass = (1..8).map{|i| chars.to_a[rand(68)]}.join
			host = request.base_url
			if resource.present?
				tokan = DateTime.now.strftime('%Q').to_s
				if resource.update(reset_password_token: tokan, activated: true, password: pass, password_confirmation: pass, user_role: "client")
					AccountBlock::SetPasswordMailer.with(account_id: resource.id, host: host, pass: pass).set_password_email.deliver_now
				end
			end
		end

		def scoped_collection
			AccountBlock::Account.where(user_role: "client")
		end

	end
end   