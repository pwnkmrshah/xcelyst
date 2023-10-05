ActiveAdmin.register BxBlockInformation::CookiesPolicy, as: "CookiesPolicy" do
  menu parent: "Website Management", label: "Cookies Policy"
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('cookies policy') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
  end

  controller do
    include ActiveAdmin::BatchActionsHelper
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