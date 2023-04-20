ActiveAdmin.register BxBlockJob::JobDatabase do
  menu label: 'Job Database'


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
