ActiveAdmin.register BxBlockRequestdemo::RequestDemo, as: "Request Demo" do
  menu label: "Request Demo"
  permit_params :first_name, :last_name, :phone_no, :email, :company_name
  actions :all, except: :new

  index do
    id_column
    column :first_name
    column :last_name
    column :phone_no
    column :email
    column :company_name
    actions
  end

  filter :first_name
  filter :last_name
  filter :phone_no
  filter :company_name

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :phone_no
      row :email
      row :company_name
    end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :phone_no
      f.input :email
      f.input :company_name
    end
    f.actions
  end
end
