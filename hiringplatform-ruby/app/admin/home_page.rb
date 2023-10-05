ActiveAdmin.register BxBlockContentManagement::HomePage, as: "HomePage" do
  menu parent: "Website Management", label: "Home Page"
  permit_params :title, :description, :active, :image, :image_file
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('home page') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

  index do
    selectable_column
    id_column
    column :title
    column :description
    column :active
    column :image do |s|
      s.image ? (image_tag url_for(s.image), size: "100x100") : ""
    end
    actions
  end

  filter :title
  filter :description

  show do
    attributes_table do
      row :title
      row :description
      row :active
      row :image do |ad|
        ad.image_file.attached? ? (image_tag url_for(ad.image_file), size: "200x200") : ""
      end
    end
  end

  filter :title
  filter :active

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
      f.input :active
      f.input :image_file, :as => :file, :hint => f.object.image.present? ? (image_tag object.image, size: "200x200") : content_tag(:span, "please upload image")
    end
    f.actions
  end

  controller do
    after_update :update_image
    after_create :update_image

    def update_image(resource)
      if resource.persisted?
        resource.update(image: url_for(resource.image_file)) if resource.image_file.present?
      end
    end

    def create
      banner = BxBlockContentManagement::HomePage.where(active: true)
      if banner.length >= 1 && params["home_page"]["active"].to_i == 1
        flash[:alert] = "All ready one banner is active"
        redirect_to(new_admin_home_page_path) and return
      end
      super
    end

    def update
      id = params["id"].to_i
      banner = BxBlockContentManagement::HomePage.where(active: true)
      if banner.length >= 1 && params["home_page"]["active"].to_i == 1 && banner[0].id != id
        flash[:alert] = "All ready one banner is active"
        redirect_to(edit_admin_home_page_path(id)) and return
      end
      super
    end
  end
end
