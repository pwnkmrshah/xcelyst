ActiveAdmin.register BxBlockDatabase::EmailTemplate, as: "EmailTemplate" do
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('email template') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
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
