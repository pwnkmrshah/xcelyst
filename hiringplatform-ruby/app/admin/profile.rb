# ActiveAdmin.register BxBlockProfile::Profile, as: 'Profile' do
#     menu parent: "Profile management", label: "Profile"

#     permit_params   :address, :postal_code, :account_id, :photo, :profile_role, :city, :about_business   
#     actions :all, except: :new

#     index do
#       id_column
#       column :country
#       column :address
#       column :postal_code
#       column :account_id
#       column :photo
#       column :profile_role
#       column :city
#     #   colimn :about_business
#       actions
#     end
  
#     show do |profile|
#       attributes_table do
#         # row :country
#         row :address
#         row :postal_code
#         row :account_id
#         row :photo
#         row :profile_role
#         row :city
#         row :about_business
#       end
#       panel "Award" do
#         table_for(profile.awards) do
#           column :title
#           column :associated_with
#           column :issuer
#           column :issue_date
#           column :description
#           column :make_public
#           column :profile_id
#         end
#       end
#       panel "Career Experiences" do
#         table_for(profile.career_experiences) do
#           column :job_title
#           column :start_date
#           column :end_date
#           column :company_name
#           column :description
#           column :current_salary
#           column :notice_period
#           column :notice_period_end_date
#           column :currently_working_here 
#         end
#       end
#       panel "Course" do
#         table_for(profile.courses) do
#           column :course_name
#           column :duration
#           column :year
#           column :profile_id
#         end
#       end
#       panel "Current annual salary" do
#         table_for(profile.current_annual_salaries) do
#           column :current_annual_salary
#         end
#       end
#       panel "Current status" do
#         table_for(profile.current_status) do
#           column :most_recent_job_title
#           column :company_name
#           column :notice_period
#           column :end_date
#         end
#       end
#       panel "Degree" do
#         table_for(profile.degrees) do
#           column :degree_name
#         end
#       end
#       panel "Educational qualification" do
#         table_for(profile.educational_qualifications) do
#           column :school_name
#           column :start_date
#           column :end_date
#           column :grades
#           column :description
#         end
#       end
      
#       panel "Hobby" do
#         table_for(profile.hobbies) do
#           column :title
#           column :category
#           column :description
#           column :make_public
#         end
#       end
#       panel "Project" do
#         table_for(profile.projects) do
#           column :project_name
#           column :start_date
#           column :end_date
#           column :add_members
#           column :url
#           column :description
#           column :make_projects_public
#         end
#       end
#       panel "Publication patent" do
#         table_for(profile.publication_patent) do
#           column :title
#           column :publication
#           column :authors
#           column :url
#           column :description
#           column :make_public
#         end
#       end
#       panel "Test score and courses" do
#         table_for(profile.test_score_and_courses) do
#           column :title
#           column :associated_with
#           column :score
#           column :test_date
#           column :description
#           column :make_public
#         end
#       end
#       panel "Industries" do
#         table_for(profile.industries) do
#           column :industry_name
#         end
#       end
#       panel "Associateds" do
#         table_for(profile.associateds) do
#           column :associated_with_name
#         end
#       end
#       panel "Associated projects" do
#         table_for(profile.associated_projects) do
#           column :project_id
#           column :associated_id
#         end
#       end
#       panel "Language" do
#         table_for(profile.languages) do
#           column :language
#           column :proficiency
#         end
#       end
#       panel "System experiences" do
#         table_for(profile.system_experiences) do
#           column :system_experience
#         end
#       end
#       panel "Career experience employment type" do
#         table_for(profile.career_experience_employment_types) do
#           column :career_experience_id
#           column :employment_type_id
#         end
#       end
#       panel "Career experience system experiences" do
#         table_for(profile.career_experience_system_experiences) do
#           column :career_experience_id
#           column :system_experience_id
#         end
#       end
#       panel "Career experience industry" do
#         table_for(profile.career_experience_industry) do
#           column :career_experience_id
#           column :industry_id
#         end
#       end
#       panel "Degree educational qualifications" do
#         table_for(profile.degree_educational_qualifications) do
#           column :educational_qualification_id
#           column :degree_id
#         end
#       end
#       panel "Educational qualification field study" do
#         table_for(profile.educational_qualification_field_study) do
#           column :educational_qualification_id
#           column :field_study_id
#         end
#       end
#       panel "Employment types" do
#         table_for(profile.employment_types) do
#           column :employment_type_name
#         end
#       end
#       panel "Field study" do
#         table_for(profile.field_study) do
#           column :field_of_study
#         end
#       end
#     end
# end
