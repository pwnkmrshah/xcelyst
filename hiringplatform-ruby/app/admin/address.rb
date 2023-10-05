ActiveAdmin.register BxBlockAddress::LocationAddress, as: "Address" do
  menu parent: "Website Management", label: "Address"
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('address') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

  permit_params :country, :address, :email, :phone, :order

  index do
    selectable_column
    id_column
    column :country
    column :address 
    column :email
    column :phone 
    column :order 
    actions
  end

  filter :country
  filter :address
  filter :email
  filter :phone
  filter :order

  form do |f|
    f.inputs do
      f.input :country, as: :string
      f.input :address
      f.input :email
      f.input :phone 
      f.input :order, as: :select, collection: (1..20).each do |count| count end
    end
    f.actions
  end

  show do
    attributes_table do 
      row :country
      row :address
      row :email
      row :phone 
      row :order
    end
  end

  
end
