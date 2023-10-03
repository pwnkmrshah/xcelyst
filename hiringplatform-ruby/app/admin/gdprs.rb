ActiveAdmin.register BxBlockInformation::Gdpr, as: "Gdpr" do
  menu parent: "Website Management", label: "Gdpr"

  permit_params :title, :description

  index do
    render partial: 'admin/batch_action'
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