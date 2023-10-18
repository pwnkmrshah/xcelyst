ActiveAdmin.register BxBlockContentManagement::MemberBio, as: "MemberBio" do
  menu parent: "Website Management", label: "Member Bio"
  permit_params :name, :description, :position, :facebook_link, :linkedin_link, :twitter_link, :content_type_id, :image_file, :order
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('member bio') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
  end

  index do
    selectable_column
    id_column
    column :name
    column :description do |content|
      if content.description == ""
        "empty"
      else
        content.description
      end
    end
    column :position do |content|
      if content.position == ""
        "empty"
      else
        content.position
      end
    end
    column :order
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :position
      row :facebook_link
      row :linkedin_link
      row :twitter_link
      row :order
      row :image do |ad|
        if ad.image_file.present?
          image_tag url_for(ad.image_file), size: "400x400"
        end
      end
    end
  end

  filter :name
  filter :position

  form do |f|
    f.inputs do
      f.input :name
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
      f.input :position
      f.input :facebook_link
      f.input :linkedin_link
      f.input :twitter_link
      f.input :order, as: :select, collection: (1..20).each do |a| a end
      f.input :content_type_id, as: :select, include_blank: false, collection: BxBlockContentManagement::ContentType.where(type: "MemberBio")
      f.input :image_file, :as => :file, :hint => f.object.image.present? ? (image_tag object.image, size: "200x200") : content_tag(:span, "please upload image")
    end
    f.actions
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

    def create
      banner = BxBlockContentManagement::HomePage.where(active: true)
      if banner.length >= 1
        flash[:alert] = "All ready one banner is active"
        redirect_to(new_admin_home_page_path) and return
      end
      super
    end
  end
end
