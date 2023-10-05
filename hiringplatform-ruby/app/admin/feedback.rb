ActiveAdmin.register BxBlockScheduling::FeedbackInterview, as: "Feedback Interview" do
  menu label: "Feedback Interview"
  permit_params :name
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('feedback interview') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
  end

  controller do
    include ActiveAdmin::BatchActionsHelper
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
