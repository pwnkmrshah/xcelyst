ActiveAdmin.register BxBlockDatabase::EmailTemplateHeader, as: 'Email Header' do
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('email header') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

  form partial: 'bx_block_database/email_template_header/form'
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
