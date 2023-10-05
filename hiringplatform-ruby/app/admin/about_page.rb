ActiveAdmin.register BxBlockAboutpage::AboutPage, as: "About Page" do
  menu parent: "Website Management", label: "About Page"
  permit_params :title, :description, :image_file, :image
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('about page') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

  index do
    selectable_column
    id_column
    column :title do |aboutpage|
      aboutpage.title.present? ? aboutpage.title : "Title not found"
    end
    column :description do |aboutPage|
      if aboutPage.description == ""
        "empty"
      else
        aboutPage.description
      end
    end
    column :image do |s|
      s.image ? (image_tag url_for(s.image), size: "100x100") : "Image Not found"
    end

    column :preview do |obj|
      span :class => "get_preview button", "data-id": obj.id do
        "preview"
      end
    end
    actions
    # actions do |obj|
    #   button :class => "get_preview", "data-id": obj.id do
    #     "preview"
    #   end
    # end
  end

  # collection_action :preview_data do 
  #   render "/admin/preview_about_page"
  # end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description, as: :quill_editor, input_html: { data: { options: { modules: { toolbar: [%w[bold italic underline strike],
                                                                                                  %w[blockquote code-block],
                                                                                                  [{ 'list': "ordered" }, { 'list': "bullet" }],
                                                                                                  [{ 'align': [] }],
                                                                                                  ["link"],
                                                                                                  [{ 'size': ["small", false, "large", "huge"] }],
                                                                                                  [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                                                                                                  [{ 'indent': "-1" }, { 'indent': "+1" }],
                                                                                                  [{ 'direction': "rtl" }],
                                                                                                  [{ 'color': [] }, { 'background': [] }],
                                                                                                  [{ 'font': [] }],
                                                                                                  ["clean"]] },
                                                                              theme: "snow" } } }
      f.input :image_file, :as => :file, :hint => f.object.image.present? ? (image_tag object.image, size: "200x200") : content_tag(:span, "please upload image")
        if f.object&.image_file&.attached? && f.object.id
          if f.object.image_file.id
            div :class=> "row" do
              div :class=> "col-xs-4" do
                link_to "delete", delete_about_page_image_admin_about_page_path(f.object.id, image_id: f.object.image_file.id), method: :delete,data: { confirm: 'Are you sure?' }
              end
            end
          end
        end
    end
    f.actions
  end

  member_action :delete_about_page_image, method: :delete do
    @pic = ActiveStorage::Attachment.find(params[:image_id])
    @pic.purge_later
    resource.update(image: nil)
    redirect_back(fallback_location: edit_admin_about_page_path(params[:id]))
  end

  filter :title

  show do
    attributes_table do
      row :title
      row :description
      row :image do |ad|
        ad.image_file.attached? ? (image_tag url_for(ad.image_file), size: "200x200") : ""
      end
    end
  end

  controller do
    after_update :update_image
    after_create :update_image

    def update_image(resource)
      if resource.persisted?
        resource.update(image: url_for(resource.image_file)) if resource.image_file.present?
      end
    end
  end
end
