ActiveAdmin.register BxBlockCfzoomintegration3::Zoom, as: "Zoom User" do
	
	actions :index, :show

	index do
		id_column
		column :first_name
		column :last_name
		column :email
		column :zoom_user_id
		column :status
	end

	filter :first_name
  filter :last_name
  filter :email
  filter :zoom_user_id
	
	action_item :only => :index do
	  link_to 'Sync User', sync_zoom_account_users_admin_zoom_users_path, method: :post
	end

	collection_action :sync_zoom_account_users, :method => :post do
		x = BxBlockCfzoomintegration3::ZoomOperations.new.get_zoom_users
		if x.success?
			redirect_to admin_zoom_users_path, flash: {:notice => x.message }
		else
			flash[:alert] = x.message
			redirect_to admin_zoom_users_path
		end
	end

end   