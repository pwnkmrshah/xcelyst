ActiveAdmin.register BxBlockDomain::Domain, as: "Domain" do
  menu parent: "Job Functions", label: "Domain", priority: 2
  permit_params :name

  action_item :add, only: :show do
    link_to "New Category", new_admin_category_path(domain_id: params[:id])
  end

  index do
    id_column
    column :name
    actions
  end

  filter :name

  show do
    attributes_table do
      row :name
    end
  end
end
