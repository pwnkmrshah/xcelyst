ActiveAdmin.register BxBlockBusinessFunction::BusinessCategory, as: "Skill Category" do
  menu parent: ["Website Management",  "Business Functions"], label: "Vertical Category"
  permit_params :name, :business_domain_id
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('skill category') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

  action_item :add, only: :show do
    link_to "New Sub Category", new_admin_skill_sub_category_path(business_category_id: params[:id])
  end

  index do
    selectable_column
    id_column
    column :name
    column "Domain Name" do |object|
      object.business_domain.name
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row "Domain Name" do |object|
        object.business_domain.name
      end
    end
  end

  filter :name

  form do |f|
    if !f.object.business_domain_id.present?
      if params[:business_domain_id]
        f.inputs do
          f.input :name
          f.input :business_domain_id, :input_html => { :value => params[:business_domain_id] }, as: :hidden
        end
        f.actions do
          f.action :submit
        end
      else
        f.inputs do
          f.input :name
          f.input :business_domain_id, as: :select, include_blank: false, collection: BxBlockBusinessFunction::BusinessDomain.all
        end
        f.actions
      end
    else
      f.inputs do
        f.input :name
        f.input :business_domain_id, as: :select, include_blank: false, collection: BxBlockBusinessFunction::BusinessDomain.all
      end
      f.actions do
        f.action :submit
      end
    end
  end
end
