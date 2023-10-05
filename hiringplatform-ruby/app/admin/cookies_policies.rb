ActiveAdmin.register BxBlockInformation::CookiesPolicy, as: "CookiesPolicy" do
  menu parent: "Website Management", label: "Cookies Policy"
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('cookies policy') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

  permit_params :title, :description

  index do
    selectable_column
    id_column
    column :title
    column :description
    actions
  end

  filter :title
  filter :description
  
  show do
    attributes_table do
      row :id
      row :title
      row :description
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.semantic_errors *f.object.errors.keys
      f.input :title
      section :class=> "quill_editor_row" do
        f.input :description, as: :quill_editor
      end
    end
    f.actions
  end
end