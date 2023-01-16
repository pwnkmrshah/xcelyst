ActiveAdmin.register BxBlockDatabase::DownloadLimit, as: "DownloadLimit" do

  permit_params :no_of_downloads

  actions :index, :edit, :update


  index do
    selectable_column
    id_column
    column :no_of_downloads
    column :created_at
    column :updated_at

    actions
  end

  filter :no_of_downloads

  form do |f|
    f.inputs do
      f.input :no_of_downloads
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
