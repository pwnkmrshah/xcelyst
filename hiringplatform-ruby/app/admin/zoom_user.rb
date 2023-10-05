ActiveAdmin.register BxBlockCfzoomintegration3::Zoom, as: "Zoom User" do
	batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('zoom user') }, confirm: "Are you sure want to delete selected items?" do |ids|
		module_name = scoped_collection.name.split("::").last
		module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
		scoped_collection.where(id: ids).destroy_all
		redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
	end

	actions :index, :show, :destroy

	index do
		selectable_column
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
	  link_to 'Sync User', sync_zoom_account_users_admin_zoom_users_path, method: :post if current_user_admin.can_sync_zoom_user?(current_user_admin)
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