ActiveAdmin.register BxBlockBusinessFunction::BusinessDomain, as: "Skill Domain" do
  menu parent: ["Website Management",  "Business Functions"], label: "Vertical Domain"
  permit_params :name
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('skill domain') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

  action_item :add, only: :show do
    link_to "New Skill Category", new_admin_skill_category_path(business_domain_id: params[:id])
  end

  index do
    selectable_column
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
