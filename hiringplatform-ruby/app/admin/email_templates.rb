ActiveAdmin.register BxBlockDatabase::EmailTemplate, as: "EmailTemplate" do

  index do
    render partial: 'admin/batch_action'
    selectable_column
    id_column
    column :template_name
    column :label
    column :from
    column :to
    column :subject
    actions
  end

  show do
    attributes_table do
      row :template_name
      row :label
      row :from
      row :to
      row :subject
      row :body do |obj|
        obj.body&.html_safe
      end    
    end    
  end

  form partial: 'bx_block_database/email_template/form'

  permit_params :from, :to, :subject, :body, :template_name, :label
end
