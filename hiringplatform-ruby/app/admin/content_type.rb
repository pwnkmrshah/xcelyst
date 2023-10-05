ActiveAdmin.register BxBlockContentManagement::ContentType, as: "ContentType" do
  menu parent: "Website management", label: "Content Type"
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('content type') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
  end

  controller do
    include ActiveAdmin::BatchActionsHelper
  end

  permit_params :name, :type

  index do
    selectable_column
    id_column
    column :name
    column :type
    actions
  end

  filter :name
  filter :type

  show do
    attributes_table do
      row :name
      row :type
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :type
    end
    f.actions
  end
end
