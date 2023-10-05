ActiveAdmin.register BxBlockContentManagement::ContentVideo, as: "ContentVideo" do
  menu parent: "Website Management", label: "Content Video"
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('content video') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

  permit_params :separate_section, :headline, :description, :thumbnails, :content_type_id, :image, :image_file, :video_file, :video_url, :active

  index do
    selectable_column
    id_column
    column :separate_section do |content|
      if content.separate_section == ""
        "empty"
      else
        content.separate_section
      end
    end
    column :headline
    column :description do |content|
      if content.description == ""
        "empty"
      else
        content.description
      end
    end
    column :thumbnails do |content|
      if content.thumbnails == ""
        "empty"
      else
        content.thumbnails
      end
    end
    column :active
    column :image do |s|
      s.image ? (image_tag s.image, size: "100x100") : ""
    end
    actions
  end

  filter :headline
  filter :thumbnails
  filter :separate_section

  show do
    attributes_table do
      row :separate_section
      row :headline
      row :description
      row :thumbnails
      row :active
      row :image do |ad|
        ad.image ? (image_tag ad.image, size: "200x200") : ""
      end
      row :video do |ad|
        if ad.video_url
          video(width: 480, height: 320, controls: true) do
            source(src: ad.video_url)
          end
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :separate_section
      f.input :headline
      f.input :description
      f.input :thumbnails
      f.input :content_type_id, as: :select, include_blank: false, collection: BxBlockContentManagement::ContentType.where(type: "Videos")
      f.input :active
      f.input :image_file, :as => :file, :hint => f.object.image.present? ? (image_tag object.image, size: "200x200") : content_tag(:span, "please upload image")
      f.input :video_file, :as => :file, :hint => f.object.video_url.present? ? "" : content_tag(:span, "please upload")
      div do
        if f.object.video_url
          video(width: 480, height: 320, controls: true) do
            source(src: f.object.video_url)
          end
        end
      end
    end
    f.actions
  end

  controller do
    after_update :update_image
    after_create :update_image

    def update_image(resource)
      if resource.persisted?
        resource.update(image: url_for(resource.image_file)) if resource.image_file.present?
        resource.update(video_url: url_for(resource.video_file)) if resource.video_file.present?
      end
    end

    def create
      vidoes = BxBlockContentManagement::ContentVideo.where(active: true, content_type_id: params["content_video"]["content_type_id"].to_i)
      if vidoes.length >= 2 && params["content_video"]["active"].to_i == 1
        flash[:alert] = "All Ready two videos active"
        redirect_to(new_admin_content_video_path) and return
      end
      super
    end

    def update
      id = params["id"].to_i
      vidoes = BxBlockContentManagement::ContentVideo.where(active: true, content_type_id: params["content_video"]["content_type_id"].to_i)
      videos_ids = vidoes.map(&:id)
      if vidoes.length >= 2 && params["content_video"]["active"].to_i == 1 && !videos_ids.include?(id)
        flash[:alert] = "All Ready two videos active"
        redirect_to(edit_admin_content_video_path(id)) and return
      end
      super
    end
  end
end
