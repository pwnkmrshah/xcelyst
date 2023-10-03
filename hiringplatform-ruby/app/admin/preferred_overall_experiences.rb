ActiveAdmin.register BxBlockPreferredOverallExperiences::PreferredOverallExperiences, as: "Overall Experiences" do
  menu parent: "Job Functions", label: "Overall Experiences",  priority: 4
  permit_params :experiences_year, :level, :grade, :minimum_experience, :maximum_experience

  index do
    render partial: 'admin/batch_action'
    selectable_column
    id_column
    column :experiences_year
    column :level
    column :grade
    column :minimum_experience do |obj|
      obj.minimum_experience || "-"
    end
    column :maximum_experience do |obj|
      obj.maximum_experience || "-"
    end
    actions
  end

  filter :level
  filter :experiences
  filter :grade

  show do
    attributes_table do
      row :experiences_year
      row :level
      row :grade
      row :minimum_experience
      row :maximum_experience
    end
  end

  form do |f|
    f.inputs do
      f.input :experiences_year
      f.input :level
      f.input :grade
    end
    f.actions
  end

  controller do
    before_update :update_params
    before_create :update_params

    def update_params(resources)
      if resources[:experiences_year].include?("-")
        arr = resources[:experiences_year].split("-")
        resources.update(minimum_experience: arr[0], maximum_experience: arr[1])
      else
        resources.update(minimum_experience: resources[:experiences_year])
      end
    end
  end
end
