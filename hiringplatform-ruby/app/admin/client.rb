ActiveAdmin.register AccountBlock::Account, as: "Client" do
	menu parent: ["Platform Users",  "Client"], label: "Client", if: proc { current_user_admin.present? && current_user_admin.can_read_account_block_for_client?(current_user_admin) }
	batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('client') }, confirm: "Are you sure want to delete selected items?" do |ids|
	    batch_destroy_action(ids, scoped_collection)
	end
	breadcrumb do
	    [
	      link_to('Admin', admin_root_path),
	      link_to('Clients', admin_clients_path)
	    ].compact
  	end

	index do
		selectable_column
		id_column
		column :first_name
		column :last_name
		column :email
		column :company_name
		column :created_at
		actions
	end

	action_item :add, only: :show do
		link_to 'Reset Password', change_password_account_block_accounts_path(id: params[:id])
	end

  form partial: 'account_block/accounts/client_signup'

	filter :email
	filter :first_name
	filter :last_name
	
	show do
		attributes_table do
			row :first_name
			row :last_name
			row :email
			row :current_city
			row :company_name
			row :interviewers do |obj|
				obj.interviewers
			end
			row :managers do |obj|
				obj.managers
			end
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
  		include ActiveAdmin::BatchActionsHelper

		def create
		    @client = AccountBlock::Account.new(permit_params)
	        send_email @client
	        begin
			    if @client.save!
			        redirect_to admin_client_path(@client), notice: 'Account was successfully created.'
			    else
			        redirect_to admin_clients_path, alert: @client.errors.full_messages.first
			    end
	        rescue Exception => e
    			redirect_to new_admin_client_path, alert: e.message
	        end
		end

		def update
		    @client = AccountBlock::Account.find(params[:id])
		    if @client.update(permit_params)
		        redirect_to admin_client_path(@client), notice: 'Account was successfully updated.'
		    else
		        redirect_to edit_admin_client_path, alert: @client.errors.full_messages.first
		    end
		end

		def send_email resource
			chars = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a + ['!', '@', '#', '$', '&', '*']
			pass = (1..8).map{|i| chars.to_a[rand(68)]}.join
			host = ENV['REMOTE_URL']
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

		def batch_action
			begin
				scoped_collection.where(id:params[:collection_selection]).destroy_all
				redirect_to admin_clients_path, notice: 'Accounts deleted successfully.'
			rescue StandardError => e
				redirect_to admin_clients_path, notice: e.message
			end
		end

		private

		def permit_params
		  params.require(:account).permit(
		    :first_name, :last_name, :current_city, :email, :company_name, :user_role,
		    interviewers_attributes: [:id, :name, :email, :_destroy], managers_attributes: [:id, :name, :email, :_destroy]
		  )
		end
	end
end   