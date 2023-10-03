ActiveAdmin.register BxBlockContentManagement::ContentText, as: "Blogs" do
  menu parent: "Website Management", label: "Blogs"
  permit_params :headline, :content, :hyperlink, :affiliation, :synopsis, :content_type_id, images_file: [], images: []

  index do
    render partial: 'admin/batch_action'
    selectable_column
    id_column
    column :headline
    column :content
    column :hyperlink do |text|
      if text.hyperlink == ""
        "empty"
      else
        text.hyperlink
      end
    end
    column :affiliation do |text|
      if text.affiliation == ""
        "empty"
      else
        text.affiliation
      end
    end
    actions
  end
  filter :headline

  show do
    attributes_table do
      row :headline
      row :synopsis
      row :content
      row :hyperlink
      row :affiliation
      row :images do |ad|
        if ad.images.present? && ad.images.length > 0
          ad.images.each do |image|
            div do
              image_tag(image, size: "200x200")
            end
          end
        end
      end
    end
  end

  filter :heading

  form do |f|
    f.inputs do
      f.input :headline
      f.input :synopsis, as: :quill_editor, input_html: { data: { options: { modules: { toolbar: [%w[bold italic underline strike],
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
      f.input :content, as: :quill_editor, input_html: { data: { options: { modules: { toolbar: [%w[bold italic underline strike],
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
      f.input :hyperlink
      f.input :affiliation
      f.input :content_type_id, as: :select, include_blank: false, collection: BxBlockContentManagement::ContentType.where(type: "Text")
      f.input :images_file, :as => :file, input_html: { multiple: true }, :hint => f.object.images.present? && f.object.images.length > 0 ? (image_tag f.object.images.first, size: "200x200") : content_tag(:span, "please upload image")
    end
    f.actions
  end

  controller do
    after_update :update_image
    after_create :update_image

    def update_image(resource)
      if resource.persisted?
        images = []
        images = resource.images_file.map do |image|
          url_for(image)
        end
        resource.update(images: images) if images.length > 0
      end
    end
  end
end
