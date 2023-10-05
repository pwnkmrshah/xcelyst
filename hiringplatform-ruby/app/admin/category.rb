ActiveAdmin.register BxBlockDomainCategory::DomainCategory, as: "Category" do
  menu parent: "Job Functions", label: "Category", priority: 1
  permit_params :name, :domain_id
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('category') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end
  
  action_item :add, only: :show do
    link_to "New Sub Category", new_admin_sub_category_path(domain_category_id: params[:id])
  end

  index do
    selectable_column
    id_column
    column :name do |text|
      if text.name == ""
        "empty"
      else
        text.name
      end
    end
    column "Domain Name" do |object|
      object.domain.name
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row "Domain Name" do |object|
        object.domain.name
      end
    end
  end

  filter :name

  form do |f|
    if !f.object.domain_id.present?
      if params[:domain_id]
        f.inputs do
          f.input :name
          f.input :domain_id, :input_html => { :value => params[:domain_id] }, as: :hidden
        end
        f.actions do
          f.action :submit
          f.cancel_link(admin_domain_path(params[:domain_id]))
        end
      else
        f.inputs do
          f.input :name
          f.input :domain, as: :select, include_blank: false, collection: BxBlockDomain::Domain.all
        end
        f.actions
      end
    else
      f.inputs do
        f.input :name
        f.input :domain, as: :select, include_blank: false, collection: BxBlockDomain::Domain.all
      end
      f.actions do
        f.action :submit
        f.cancel_link(admin_domain_path(f.object.domain_id))
      end
    end
  end
end
