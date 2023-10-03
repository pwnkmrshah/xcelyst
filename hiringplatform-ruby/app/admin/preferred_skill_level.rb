ActiveAdmin.register BxBlockPreferredOverallExperiences::PreferredSkillLevel, as: "Skill Experiences" do
  menu parent: "Job Functions", label: "Skill Level"
  permit_params :experiences_year, :level

  index do
    render partial: 'admin/batch_action'
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
