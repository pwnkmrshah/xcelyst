ActiveAdmin.register BxBlockContactUs::Contact, as: "Contact" do
  menu label: "Contact Request", priority: 4
  permit_params :name, :phone_number, :email, :description
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('contact request') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
  end

  controller do
    include ActiveAdmin::BatchActionsHelper
  end

  index do
    selectable_column
    id_column
    column :name
    column :phone_number
    column :email
    column :description
    actions
  end

  show do
    attributes_table do
      row :name
      row :phone_number
      row :email
      row :description
    end
  end

  filter :name
  filter :phone_number
  filter :email
  filter :description

  form do |f|
    f.inputs do
      f.input :name
      f.input :phone_number
      f.input :email
      f.input :description
    end
    f.actions
  end
end
