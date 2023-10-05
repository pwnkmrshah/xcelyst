ActiveAdmin.register BxBlockBusinessFunction::BusinessSubCategory, as: "Skill Sub Category" do
  menu parent: ["Website Management",  "Business Functions"], label: "Vertical Sub Category"
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('skill sub category') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

  permit_params :name, :business_category_id

  index do
    selectable_column
    id_column
    column :name
    column "Category Name" do |object|
      object.business_category.name
    end
    column "Doamin Name" do |object|
      object.business_category.business_domain.name
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row "Category Name" do |object|
        object.business_category.name
      end
      row "Doamin Name" do |object|
        object.business_category.business_domain.name
      end
    end
  end

  filter :name

  form do |f|
    if !f.object.business_category_id.present?
      if params[:business_category_id]
        f.inputs do
          f.input :name
          f.input :business_category_id, :input_html => { :value => params[:business_category_id] }, as: :hidden
        end
        f.actions do
          f.action :submit
        end
      else
        f.inputs do
          f.input :name
          f.input :business_category, as: :select, include_blank: false, collection: BxBlockBusinessFunction::BusinessCategory.all
        end
        f.actions
      end
    else
      f.inputs do
        f.input :name
        f.input :business_category, as: :select, include_blank: false, collection: BxBlockBusinessFunction::BusinessCategory.all
      end
      f.actions do
        f.action :submit
      end
    end
  end
end
