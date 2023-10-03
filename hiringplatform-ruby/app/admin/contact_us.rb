ActiveAdmin.register BxBlockContactUs::Contact, as: "Contact" do
  menu label: "Contact Request", priority: 4
  permit_params :name, :phone_number, :email, :description

  index do
    render partial: 'admin/batch_action'
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
