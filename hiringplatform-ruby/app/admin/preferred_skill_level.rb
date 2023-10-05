ActiveAdmin.register BxBlockPreferredOverallExperiences::PreferredSkillLevel, as: "Skill Experiences" do
  menu parent: "Job Functions", label: "Skill Level"
  permit_params :experiences_year, :level
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('skill experiences') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
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
