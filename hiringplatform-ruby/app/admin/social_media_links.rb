ActiveAdmin.register BxBlockContentManagement::SocialMediaLink, as: "Social Media Links" do
  menu parent: "Website Management", label: "Social Media Links"
  permit_params :title, :link

  index do
    render partial: 'admin/batch_action'
    selectable_column
    id_column
    column :title
    column :link
    actions
  end

  filter :title
  filter :link

  show do
    attributes_table do
      row :title
      row :link
    end
  end

  form do |f|
    f.inputs do
      f.input :title, as: :select, include_blank: false, collection: ["Facebook", "YouTube", "Whatsapp", "Instagram", "LinkedIn", "Twitter", "Reddit"]
      f.input :link
    end
    f.actions
  end
end
