ActiveAdmin.register BxBlockDomain::Domain, as: "Domain" do
  menu parent: "Job Functions", label: "Domain", priority: 2
  permit_params :name
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('domain') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
  end

  controller do
    include ActiveAdmin::BatchActionsHelper
  end

  action_item :add, only: :show do
    link_to "New Category", new_admin_category_path(domain_id: params[:id])
  end

  index do
    selectable_column
    id_column
    column :name
    actions
  end

  filter :name

  show do
    attributes_table do
      row :name
    end
  end
end
