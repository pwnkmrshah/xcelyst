# ActiveAdmin.register BxBlockContentManagement::AudioPodcast, as: 'AudioPodcast' do
#   menu parent: "Website Management", label: "Audio podcast"
#   permit_params :heading,:description, :content_type_id, :image_file, audio_attributes: [:attached_item_type, :attached_item_id, :audio]

#   index do
#     id_column
#     column :heading
#     column :description do |podcast|
#       if podcast.description == ""
#         "empty"
#       else
#         podcast.description
#       end
#     end
#     actions
#   end

#   show do
#     attributes_table do
#       row :heading
#       row :description
#       row :image do |ad|
#         ad.image_file.attached? ? (image_tag url_for(ad.image_file), size: "400x400") : ''
#       end
#       row :audio do |ad|
#         if ad.audio_url
#           audio(controls: true) do
#             source(src: ad.audio_url)
#           end
#         end
#       end
#     end
#   end

#   filter :heading
#   filter :description

#   form do |f|
#     f.inputs do
#       f.input :heading
#       f.input :description
#       f.input :content_type_id, as: :select, collection: BxBlockContentManagement::ContentType.where(type: "AudioPodcast")
#       f.input :image_file, :as => :file, :hint => f.object.image.present? ? (image_tag object.image, size: "200x200") : content_tag(:span, "please upload image")
#       f.has_many :audio do |at|
#         at.input :audio, as: :file, :hint => f.object.audio_url.present? ? "" : content_tag(:span, "please upload image")
#       end
#       if f.object.audio_url
#         audio(controls: true) do
#           source(src: f.object.audio_url)
#         end
#       end
#     end
#     f.actions
#   end

#   controller  do
#     after_update :update_image
#     after_create :update_image

#     def update_image resource
#       if resource.persisted?
#         resource.update(image: url_for(resource.image_file)) if resource.image_file.present?
#         resource.update(audio_url: resource.audio_url) if resource.audio
#       end
#     end
#   end
# end
