ActiveAdmin.register BxBlockManager::Manager, as: "Manager" do
  menu parent: ["Platform Users",  "Client"], label: "Hiring Manager"
  permit_params :name, :email, :account_id
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('manager') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

  index do
    selectable_column
    id_column
    column :name
    column :email
    column "client" do |object|
      object.account.first_name + " " + object.account.last_name
    end
    actions
  end

  filter :name
  filter :email

  show do
    attributes_table do
      row :name
      row :email
      row "client" do |object|
        object.account.first_name + " " + object.account.last_name
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :account_id, as: :select, collection: AccountBlock::Account.where(user_role: "client").collect { |step| [step.first_name + " " + step.last_name, step.id] }
    end
    f.actions
  end
end
