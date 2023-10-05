ActiveAdmin.register BxBlockContactUs::Contact, as: "Contact" do
  menu label: "Contact Request", priority: 4
  permit_params :name, :phone_number, :email, :description
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('contact request') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
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
