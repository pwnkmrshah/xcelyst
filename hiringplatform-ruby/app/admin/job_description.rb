ActiveAdmin.register BxBlockJobDescription::JobDescription, as: 'Job Description' do
  menu label: 'Job Description', priority: 5
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('job description') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

  actions :index, :show,:destroy

  scope :automatic_jd
  scope :manual_jd

  filter :job_title
  filter :role_title
  filter :location

  index do
    selectable_column
    id_column
    column :document_id
    column :role_name do |obj|
      obj.role.name
    end
    column :job_title do |obj|
      obj.job_title || "-"
    end
    column :role_title do |obj|
      obj.role_title || "-"
    end
    column :location do |obj|
      obj.location || "-"
    end
    column :company_description do |obj|
      obj.company_description || "-"
    end
    column :job_responsibility do |obj|
      obj.job_responsibility || "-"
    end
    actions
  end

  show do
    attributes_table do
      row :job_title
      row :role_title
      row :location
      row :jd_file do |obj|
        if obj.jd_file.present?
          a class: 'button', href: url_for(obj.jd_file), target: '_blank', download: '' do 
            "Download File"
          end
        end
      end
      row :role_id_ do |obj|
        obj.role.id
      end
      row :name do |obj|
        obj.role.name
      end
      row :position do |obj|
        obj.role.position
      end
      row :managers do |obj|
        managers = obj.role.managers
        if managers.present?
          if obj.jd_type == "automatic"
            data = []
            managers.each do |manager|
              if manager['id'].present?
                parsed = JSON.parse(manager)
                data << parsed['email'] 
              else
                data << manager.gsub(/[^a-zA-Z0-9\ @.]/,"") 
              end
            end
            data
          elsif obj.jd_type == "manual"
            data = []
            managers.each do |rec|
              if rec['name'].present?
                data_hash = JSON.parse(rec.gsub('=>', ':'))
                data << data_hash['email']
              else
                data << rec.gsub(/[^a-zA-Z0-9\ @.]/,"") 
              end
            end
            data
          end 
        end
      end
      row :is_closed do |obj|
        obj.role.is_closed
      end
      row :created_at do |obj|
        obj.role.created_at
      end
      row :updated_at do |obj|
        obj.role.updated_at
      end
      div :class => "panel_contents" do
        div :class => "attributes_table" do
          @jd_data = resource.parsed_jd
          style do 
            '.job-data-table {
                border-collapse: collapse;
            }
            .job-data-table td {
                border: 1px solid #000000;
                padding: 10px 20px;
            }'
          end
          table class: "job-data-table" do
            if @jd_data.present? && @jd_data['JobData'].present?
              tr do
                  td colspan: "4",align: "center" do
                    "JobData"
                  end
              end
              tr do  
                  td do  
                    "Minimum Years"
                  end
                  td colspan: "3" do 
                    if @jd_data['JobData']['MinimumYears'].present? 
                      @jd_data['JobData']['MinimumYears']['Value'].present? ? @jd_data['JobData']['MinimumYears']['Value'] : 'NA'
                    else
                      'NA'
                    end
                  end
              end
              tr do
                  td do
                    "Maximum Years"
                  end
                  td colspan: "3" do 
                    @jd_data['JobData']['MaximumYears'].present? ? @jd_data['JobData']['MaximumYears']['Value'] : 'NA'
                  end
              end
              tr do
                  td do
                    "Required Degree"
                  end
                  td colspan: "3" do 
                    @jd_data['JobData']['RequiredDegree'].present? ? @jd_data['JobData']['RequiredDegree'] : 'NA'
                  end
              end
              tr do
                  td do 
                    "Job Title"
                  end
                  td colspan: "3" do 
                    if @jd_data['JobData']['JobTitles'].present?
                      @jd_data['JobData']['JobTitles']['MainJobTitle'].present? ? @jd_data['JobData']['JobTitles']['MainJobTitle'] : 'NA'
                    else
                      'NA'
                    end
                  end
              end
              tr do 
                  td do
                    "Employer Name"
                  end
                  td colspan: "3" do
                    @jd_data['JobData']['EmployerNames']['MainEmployerName']
                  end
              end
              if @jd_data['JobData']['Degrees'].present?
                @jd_data['JobData']['Degrees'].each_with_index do |degree, index|
                    tr do 
                        if index == 0
                            td rowspan: "#{@jd_data['JobData']['Degrees'].count}" do 
                              "Degrees"
                            end
                        end
                        td colspan: "3" do
                          degree['Name']
                        end
                    end
                end
              end
              tr do 
                  td do
                    "Certifications And Licenses"
                  end
                  td colspan: "3" do
                    @jd_data['JobData']['CertificationsAndLicenses'].present? ? @jd_data['JobData']['CertificationsAndLicenses'].join(", ") : 'NA'
                  end
              end
              tr do 
                  td do
                    "Location"
                  end
                  td colspan: "3" do
                    if @jd_data['JobData']['CurrentLocation'].present?
                      @jd_data['JobData']['CurrentLocation']['Municipality'].present? ? @jd_data['JobData']['CurrentLocation']['Municipality'] : "NA"
                    else
                      "NA"
                    end
                  end
              end
            end 
          end

          div style: 'overflow: auto;' do 
            pre do 
              if @jd_data.present?
                @jd_data['JobData']['JobMetadata']['PlainText']
              end
            end
          end
        end
      end
    end
  end

  batch_action :destroy, confirm: "Are you sure you want to delete selected items?" do |ids|
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} job description."
  end
end
  
  