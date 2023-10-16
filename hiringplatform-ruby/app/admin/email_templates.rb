ActiveAdmin.register BxBlockDatabase::EmailTemplate, as: "EmailTemplate" do
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('email template') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
  end

  controller do
    include ActiveAdmin::BatchActionsHelper
  end

  index do
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
