ActiveAdmin.register BxBlockScheduling::FeedbackInterview, as: "Feedback Interview" do
  menu label: "Feedback Interview"
  permit_params :name

  index do
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
