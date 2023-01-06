# ActiveAdmin.register BxBlockContentManagement::Author, as: 'Author' do
#     menu parent: "Website Management", label: "Author"

#     permit_params :name,:bio
#     index do
#       id_column
#       column :name
#       column :bio
#       actions
#     end

#     filter :name
#     filter :bio

#     show do
#       attributes_table do
#         row :name
#         row :bio
#       end
#     end
#   end
