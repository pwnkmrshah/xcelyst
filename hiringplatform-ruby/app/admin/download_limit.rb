ActiveAdmin.register BxBlockDatabase::DownloadLimit, as: "DownloadLimit" do

  permit_params :no_of_downloads, :per_page_limit

  actions :index, :edit, :update


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
      f.input :per_page_limit
    end
    f.actions
  end

  # show do
  #   attributes_table do
  #     row :no_of_downloads
  #     row :created_at
  #     row :updated_at
  #   end
  # end

end
