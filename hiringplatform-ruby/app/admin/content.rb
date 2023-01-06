# ActiveAdmin.register BxBlockContentManagement::Content, as: 'Content' do
#     menu parent: "Website Management", label: "Content"

#     permit_params :status#, :publish_date, :archived, :feature_article, :feature_video,:searchable_text

#     index do
#       #id_column
#      # column :sub_category_id
#      # column :category_id
#      #column :content_type_id
#      # column :language_id
#       column :status
#     #   column :publish_date
#     #   column :archived
#     #   column :feature_article
#     #   column :feature_video
#     #   column :searchable_text
#       actions
#     end

#     show do
#       attributes_table do
#         # row :sub_category_id
#         # row :category_id
#         # row :content_type_id
#         # row :language_id
#         row :status
#         # row :publish_date
#         # row :archived
#         # row :feature_article
#         # row :feature_video
#         # row :searchable_text
#       end
#     end
#   end
