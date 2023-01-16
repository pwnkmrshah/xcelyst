ActiveAdmin.register BxBlockBusinessFunction::BusinessDomain, as: "Skill Domain" do
  menu false
  permit_params :name

  action_item :add, only: :show do
    link_to "New Skill Category", new_admin_skill_category_path(business_domain_id: params[:id])
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
