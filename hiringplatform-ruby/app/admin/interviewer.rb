ActiveAdmin.register BxBlockManager::Interviewer, as: "Interviewer" do
    menu parent: ["Platform Users",  "Client"], label: "Interviewer"
    permit_params :name, :email, :client_id
    batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('interviewer') }, confirm: "Are you sure want to delete selected items?" do |ids|
      batch_destroy_action(ids, scoped_collection)
    end
  
    controller do
      include ActiveAdmin::BatchActionsHelper
    end

    index do
      selectable_column
      id_column
      column :name
      column :email
      column "client" do |object|
        object.client.first_name + " " + object.client.last_name
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
          object.client.first_name + " " + object.client.last_name
        end
      end
    end
  
    form do |f|
      f.inputs do
        f.input :name
        f.input :email
        f.input :client_id, as: :select, collection: AccountBlock::Account.where(user_role: "client").collect { |step| [step.first_name + " " + step.last_name, step.id] }
      end
      f.actions
    end
  end
  