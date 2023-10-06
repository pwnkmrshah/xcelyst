ActiveAdmin.register BxBlockAboutpage::AboutPage, as: "About Page" do
  menu parent: "Website Management", label: "About Page"
  permit_params :title, :description, :image_file, :image
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('about page') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
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
  end

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
    include ActiveAdmin::BatchActionsHelper

    def update_image(resource)
      if resource.persisted?
        resource.update(image: url_for(resource.image_file)) if resource.image_file.present?
      end
    end
  end
end
