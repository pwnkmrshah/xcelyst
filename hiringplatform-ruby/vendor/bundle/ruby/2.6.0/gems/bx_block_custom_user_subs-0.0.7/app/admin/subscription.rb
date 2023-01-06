# module Subscription
# end

# ActiveAdmin.register BxBlockCustomUserSubs::Subscription do
#   menu label: "Subscription"
#   permit_params :name, :description, :valid_up_to, :price,:image

#   form do |f|
#     f.inputs do
#       f.input :name
#       f.input :description
#       f.input :price
#       f.input :valid_up_to
#       f.input :image, as: :file
#     end
#     f.actions

#   end

#   index  title: 'Subscriptions' do
#     id_column
#     column :name
#     column :description
#     column :price
#     column :valid_up_to
#     column :image do |s|
#       s.image.attached? ? (image_tag url_for(s.image)) : ''
#     end
#     actions
#   end
#   show do
#     attributes_table do
#       row :name
#       row :description
#       row :price
#       row :valid_up_to
#       row :image do |s|
#         s.image.attached? ? (image_tag url_for(s.image)) : ''
#       end
#     end
#   end
# end
