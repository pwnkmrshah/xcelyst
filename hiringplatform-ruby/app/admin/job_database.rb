ActiveAdmin.register BxBlockJob::JobDatabase do
  menu label: 'Job Database'
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('job database') }, confirm: "Are you sure want to delete selected items?" do |ids|
    batch_destroy_action(ids, scoped_collection)
  end

  controller do
    include ActiveAdmin::BatchActionsHelper
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :url, :job_uid, :job_title, :location, :date_published, :business_area, :area_domain, :reference_code, :employment, :responsibilities, :skills, :apply_for_job_url, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:url, :job_uid, :job_title, :location, :date_published, :business_area, :area_domain, :reference_code, :employment, :responsibilities, :skills, :apply_for_job_url, :description]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
