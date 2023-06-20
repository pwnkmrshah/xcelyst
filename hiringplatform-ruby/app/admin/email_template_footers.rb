ActiveAdmin.register BxBlockDatabase::EmailTemplateFooter, as: 'Email Footer' do
  form partial: 'bx_block_database/email_template_footer/form'
  index do
    selectable_column
    id_column
    column :enable
    actions
  end
  show do
    attributes_table do
      row :body do |obj|
        obj.body&.html_safe
      end
      row :enable
    end
  end
  permit_params :body, :enable
end
