ActiveAdmin.register BxBlockDatabase::DownloadLimit, as: "DownloadLimit" do
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('download limit') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
  end

  controller do
    include ActiveAdmin::BatchActionsHelper
  end

  permit_params :no_of_downloads, :per_page_limit

  actions :index, :edit, :update, :destroy


  index do
    selectable_column
    id_column
    column :no_of_downloads
    column :per_page_limit
    column :created_at
    column :updated_at

    actions
  end

  filter :no_of_downloads

  form do |f|
    f.inputs do
      f.input :no_of_downloads
      f.input :per_page_limit, required: true
    end
    f.actions
  end
end
