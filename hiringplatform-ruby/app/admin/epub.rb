# ActiveAdmin.register BxBlockContentManagement::Epub, as: 'Epub' do
#     menu parent: "Website Management", label: "Epub"
#     permit_params :heading, :description, :content_type_id, pdfs_file: []

#     index do
#       id_column
#       column :heading
#       column :description
#       actions
#     end

#     show do
#       attributes_table do
#         row :heading
#         row :description
#         row :pdfs_file do |ad|
#           if epub.pdfs_file
#             epub.pdfs_file.map do |ad|
#               button_to "Open Pdf", polymorphic_url(ad), method: :get, form: {target: '_blank'}
#             end
#           end
#         end
#       end
#     end

#     filter :heading

#       form do |f|
#         f.inputs do
#           f.input :heading
#           f.input :description
#           f.input :content_type_id, as: :select, collection: BxBlockContentManagement::ContentType.where(type: "Epub")
#           f.input :pdfs_file, required: true, as: :file, input_html: { multiple: true }
#         end
#         f.actions
#       end

#       controller  do
#         after_update :update_pdf
#         after_create :update_pdf

#         def update_pdf resource
#           if resource.persisted?
#             pdfs = []
#             pdfs = resource.pdfs_file.map do |pdf|
#               polymorphic_url(pdf)
#             end
#             resource.update(pdfs: pdfs) if pdfs.length > 0
#           end
#         end
#       end

# end
