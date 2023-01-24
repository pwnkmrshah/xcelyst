# ActiveAdmin.register BxBlockAdminRolePermission::AdminPermission, as: "Admin Permission" do
#   # menu false
#     menu parent: "User Management", label: "Permission Management"
#   permit_params :name

#   index do
#     id_column
#     column :name
#     actions
#   end

#   show do
#     attributes_table do
#       row :name
#     end
#   end

#   form do |f|
#     f.inputs do
#       f.input :name, as: :string
#     end
#     f.actions
#   end

#   show do
#     attributes_table do 
#       row :name
#     end
#   end
# end
