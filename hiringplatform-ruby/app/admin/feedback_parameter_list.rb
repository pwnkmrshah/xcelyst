ActiveAdmin.register BxBlockFeedback::FeedbackParameterList, as: 'Feedback Parameter' do
    menu label: "Feedback Parameter"
    permit_params :name
  
    index do
      selectable_column
      id_column
      column :name
      actions
    end
  
    form do |f|
      f.inputs do
        f.input :name
      end
      f.actions
    end
  
    filter :name
  
    show do
      attributes_table do
        row :name
      end
    end
  end
    
    