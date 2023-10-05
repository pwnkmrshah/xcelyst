ActiveAdmin.register BxBlockFeedback::FeedbackParameterList, as: 'Feedback Parameter' do
    menu label: "Feedback Parameter"
    permit_params :name
    batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('feedback parameter') }, confirm: "Are you sure want to delete selected items?" do |ids|
      module_name = scoped_collection.name.split("::").last
      module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
      scoped_collection.where(id: ids).destroy_all
      redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
    end

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
    
    