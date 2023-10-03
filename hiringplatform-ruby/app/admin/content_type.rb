ActiveAdmin.register BxBlockContentManagement::ContentType, as: "ContentType" do
  menu parent: "Website management", label: "Content Type"

  permit_params :name, :type

  index do
    render partial: 'admin/batch_action'
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
