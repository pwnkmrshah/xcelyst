ActiveAdmin.register BxBlockDatabase::EmailTemplateFooter, as: 'Email Footer' do
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('email footer') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
  end

  controller do
    include ActiveAdmin::BatchActionsHelper
  end

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
