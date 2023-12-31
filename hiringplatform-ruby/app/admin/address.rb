ActiveAdmin.register BxBlockAddress::LocationAddress, as: "Address" do
  menu parent: "Website Management", label: "Address"
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('address') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
  end

  controller do
    include ActiveAdmin::BatchActionsHelper
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
