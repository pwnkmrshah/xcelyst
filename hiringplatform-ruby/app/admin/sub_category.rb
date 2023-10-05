ActiveAdmin.register BxBlockDomainSubCategory::DomainSubCategory, as: "Sub Category" do
  menu parent: "Job Functions", label: "Sub Category", priority: 6
  permit_params :name, :domain_category_id
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('sub category') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
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
    column "Category Name" do |object|
      object.domain_category.name
      if object.domain_category.name == ""
        "empty"
      else
        object.domain_category.name
      end
    end
    column :domain_category_id do |text|
      if text.domain_category_id == ""
        "empty"
      else
        text.domain_category_id
      end
    end
    column "Doamin Name" do |object|
      object.domain_category.domain.name
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row "Category Name" do |object|
        object.domain_category.name
      end
      row "Doamin Name" do |object|
        object.domain_category.domain.name
      end
    end
  end

  filter :name

  form do |f|
    if !f.object.domain_category_id.present?
      if params[:domain_category_id]
        f.inputs do
          f.input :name
          f.input :domain_category_id, :input_html => { :value => params[:domain_category_id] }, as: :hidden
        end
        f.actions do
          f.action :submit
          f.cancel_link(admin_category_path(params[:domain_category_id]))
        end
      else
        f.inputs do
          f.input :name
          f.input :domain_category, as: :select, include_blank: false, collection: BxBlockDomainCategory::DomainCategory.all
        end
        f.actions
      end
    else
      f.inputs do
        f.input :name
        f.input :domain_category, as: :select, include_blank: false, collection: BxBlockDomainCategory::DomainCategory.all
      end
      f.actions do
        f.action :submit
        f.cancel_link(admin_category_path(f.object.domain_category_id))
      end
    end
  end
end
