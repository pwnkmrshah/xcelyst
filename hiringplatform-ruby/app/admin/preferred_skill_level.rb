ActiveAdmin.register BxBlockPreferredOverallExperiences::PreferredSkillLevel, as: "Skill Experiences" do
  menu parent: "Job Functions", label: "Skill Level"
  permit_params :experiences_year, :level
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('skill experiences') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
  end

  controller do
    include ActiveAdmin::BatchActionsHelper
  end

  index do
    selectable_column
    id_column
    column :experiences_year
    column :level
    actions
  end

  filter :level
  filter :experiences

  show do
    attributes_table do
      row :experiences_year
      row :level
    end
  end
end
