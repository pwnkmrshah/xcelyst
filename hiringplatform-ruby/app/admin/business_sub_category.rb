ActiveAdmin.register BxBlockBusinessFunction::BusinessSubCategory, as: "Skill Sub Category" do
  menu parent: ["Website Management",  "Business Functions"], label: "Vertical Sub Category"
  permit_params :name, :business_category_id

  index do
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
