ActiveAdmin.register BxBlockContentManagement::SocialMediaLink, as: "Social Media Links" do
  menu parent: "Website Management", label: "Social Media Links"
  permit_params :title, :link
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('social media links') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

  index do
    selectable_column
    id_column
    column :title
    column :link
    actions
  end

  filter :title
  filter :link

  show do
    attributes_table do
      row :title
      row :link
    end
  end

  form do |f|
    f.inputs do
      f.input :title, as: :select, include_blank: false, collection: ["Facebook", "YouTube", "Whatsapp", "Instagram", "LinkedIn", "Twitter", "Reddit"]
      f.input :link
    end
    f.actions
  end
end
