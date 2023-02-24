ActiveAdmin.register AccountBlock::Account, as: "Candidate" do
    menu parent: "Platform Users", label: "Candidate", if: proc { current_admin_user.present? && current_admin_user.can_read_account_block_for_candidate?(current_admin_user) }

    permit_params :id, :email, :first_name, :last_name, :current_city, :phone_number#, :password, :password_confirmation, :user_role, :reset_password_token
    
    actions :all, except: :new

    filter :email
    filter :first_name
    filter :last_name

    index do
      form do |f|
        div class: "align-dropdown" do
          div do
          f.label do
            "Text Message"
          end
          f.textarea class: "text_message_whasapp_acc"
          end
          div do
          f.button class: "button", id: "send_message_acc" do
            "send message"
          end
          end
        end
      end
      selectable_column
      id_column
      column :document_id
      column :first_name
      column :last_name
      column :email
      column :phone_number
      column :resume_file do |obj|
        if obj.resume_image.present?
            a class: 'button', href: url_for(obj.resume_image), target: '_blank', download: '' do 
                "Download File"
            end
        end
      end
      column :is_converted_account
      column :created_at
      actions
    end

    form do |f|
      f.inputs do
          f.input :first_name
          f.input :last_name
          f.input :current_city
          f.input :email
      end
      f.actions
    end

    show do
      attributes_table do
          row :first_name
          row :last_name
          row :email
          row :current_city
          row :resume_file do |obj|
              if obj.resume_image.present?
                  a class: 'button', href: url_for(obj.resume_image), download: '' do 
                      "Download File"
                  end
              end
          end
          row :resume_id do |obj|
              obj.user_resume.present? ? obj.user_resume.resume_id : nil
          end
          row :resume_transaction_id do |obj|
              obj.user_resume.present? ?  obj.user_resume.transaction_id : nil
          end
          row :index_id do |obj|
              obj.user_resume.present? ? obj.user_resume.index_id : nil
          end
          row :document_id do |obj|
              obj.user_resume.present? ? obj.user_resume.document_id : nil
          end
          row :created_at do |obj|
              obj.user_resume.present? ? obj.user_resume.created_at : nil
          end
          row :updated_at do |obj|
              obj.user_resume.present? ? obj.user_resume.updated_at : nil
          end
          div :class => "panel_contents" do
              div :class => "attributes_table" do
                if resource.user_resume.present?
                  user_resume = resource.user_resume
                  # @jd_data = user_resume.parsed_resume.present? ? user_resume.parsed_resume : user_resume.get_parsed_resume_data
                  @jd_data = user_resume.get_parsed_resume_data
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
                      tr do
                          td colspan: "4",align: "center" do
                            "Resume Data"
                          end
                      end
                      tr do  
                          td do  
                            "CandidateName"
                          end
                          td colspan: "3" do 
                            @jd_data['Value']['ResumeData']['ContactInformation']['CandidateName']['FormattedName'] if @jd_data['Value']['ResumeData']['ContactInformation']['CandidateName'].present?
                          end
                      end
                      tr do  
                          td do  
                            "Telephones"
                          end
                          td colspan: "3" do 
                            @jd_data['Value']['ResumeData']['ContactInformation']['Telephones'][0]['Raw'] if @jd_data['Value']['ResumeData']['ContactInformation']['Telephones'].present?
                          end
                      end
                      tr do  
                          td do  
                            "EmailAddresses"
                          end
                          td colspan: "3" do 
                            if @jd_data['Value']['ResumeData'].present?
                              if @jd_data['Value']['ResumeData']['ContactInformation'].present?
                                @jd_data['Value']['ResumeData']['ContactInformation']['EmailAddresses'].join(", ") if @jd_data['Value']['ResumeData']['ContactInformation']['EmailAddresses'].present?
                              end
                            end
                          end
                      end
                      tr do  
                          td do  
                            "Education"
                          end
                          td colspan: "3" do
                            if @jd_data['Value']['ResumeData']['Education'].present?
                              if @jd_data['Value']['ResumeData']['Education']['HighestDegree'].present?
                                if @jd_data['Value']['ResumeData']['Education']['HighestDegree']['Name'].present?
                                  @jd_data['Value']['ResumeData']['Education']['HighestDegree']['Name']['Raw'].present? ? @jd_data['Value']['ResumeData']['Education']['HighestDegree']['Name']['Raw'] : 'NA'
                                end
                              end
                            end
                          end
                      end

                      @degree_row_count = 0
                      if @jd_data['Value']['ResumeData']['Education'].present?
                        @jd_data['Value']['ResumeData']['Education']['EducationDetails'].each_with_index do |degree, index|
                          if degree['Degree'].present?
                            if degree['Degree']['Name'].present?
                              if degree['Degree']['Name']['Raw'].present?
                                @degree_row_count += 1
                              end
                            end
                          end
                        end

                        @jd_data['Value']['ResumeData']['Education']['EducationDetails'].each_with_index do |degree, index|
                          if degree['Degree'].present?
                            if degree['Degree']['Name'].present?
                              if degree['Degree']['Name']['Raw'].present?
                                tr do 
                                    if index == 0
                                        td rowspan: "#{@degree_row_count}" do 
                                          "Degrees"
                                        end
                                    end
                                    td colspan: "3" do
                                      degree['Degree']['Name']['Raw']
                                    end
                                end
                              end
                            end
                          end
                        end
                      end

                      @jd_data['Value']['ResumeData']['EmploymentHistory']['ExperienceSummary'].each_with_index do |experience, index|
                        tr do
                            if index == 0
                                td rowspan: "#{@jd_data['Value']['ResumeData']['EmploymentHistory']['ExperienceSummary'].count}" do
                                    "Experience Summary"
                                end
                            end
                            experience.each_with_index do |exp, index|
                              if index == 1
                                td colspan: "2" do
                                  exp
                                end
                              else
                                td do
                                  exp
                                end
                              end
                            end
                        end
                      end


                      if @jd_data['Value']['ResumeData']['Achievements'].present?
                          tr do
                              td do
                                "Achievements"
                              end
                              td colspan: "3" do 
                                @jd_data['Value']['ResumeData']['Achievements'].join(", ")
                              end
                          end
                      end

                      @jd_data['Value']['ResumeData']['LanguageCompetencies'].each_with_index do |language, index|
                          tr do 
                              if index == 0
                                  td rowspan: "#{@jd_data['Value']['ResumeData']['LanguageCompetencies'].count}" do 
                                    "Language Competencies"
                                  end
                              end
                              td colspan: "3" do
                                language['Language']
                              end
                          end
                      end

                      tr do
                          td do 
                            "Qualifications Summary"
                          end
                          td colspan: "3" do 
                            @jd_data['Value']['ResumeData']['QualificationsSummary']
                          end
                      end
                      
                      # @jd_data['Value']['ResumeData']['SkillsData'].each_with_index do |skill, index|
                      #     tr do
                      #         if index == 0
                      #             rowspanCountForSkills = 0
                      #             @span = []
                      #             @jd_data['Value']['ResumeData']['SkillsData'].each do |skill_data_count|
                      #                 skill_data_count['Taxonomies'].each_with_index do |taxonomy_count, index|
                      #                     tax_index = index
                      #                     taxonomy_count['SubTaxonomies'].each_with_index do |sub_taxonomy_count, index|
                      #                       if sub_taxonomy_count['Skills'].present?
                      #                         rowspanCountForSkills += sub_taxonomy_count['Skills'].count
                      #                         if index == 0
                      #                           @span.push({tax_index => sub_taxonomy_count['Skills'].count})
                      #                         else
                      #                           @span[tax_index][tax_index] += sub_taxonomy_count['Skills'].count
                      #                         end
                      #                       end
                      #                     end
                      #                 end
                      #             end
                      #             # rowspanCountForSkills = 0
                      #             # @span = Array.new(50, 0) { Array.new(50, 0) }
                      #             # @jd_data['Value']['ResumeData']['SkillsData'].each do |skill_data_count|
                      #             #     skill_data_count['Taxonomies'].each_with_index do |taxonomy_count, index|
                      #             #         puts "=================================="
                      #             #         puts  "==========Taxonomies============="
                      #             #         puts "#{index}"
                      #             #         puts "=================================="
                      #             #         tax_index = index
                      #             #         taxonomy_count['SubTaxonomies'].each_with_index do |sub_taxonomy_count, index|
                      #             #           if sub_taxonomy_count['Skills'].present?
                      #             #             rowspanCountForSkills += sub_taxonomy_count['Skills'].count
                      #             #             if index == 0
                      #             #               @span.push({tax_index => sub_taxonomy_count['Skills'].count})
                      #             #             else
                      #             #               @span[tax_index][tax_index] += sub_taxonomy_count['Skills'].count
                      #             #             end
                      #             #           end
                      #             #         end
                      #             #     end
                      #             # end
                      #             td rowspan: "#{rowspanCountForSkills}" do
                      #               "Skills"
                      #             end
                                  
                      #             skill['Taxonomies'].each_with_index do |taxonomy, index|
                      #                 if index == 0
                      #                   td rowspan: "#{@span[index][index]}" do
                      #                     taxonomy['Name']
                      #                   end
                      #                     taxonomy['SubTaxonomies'].each_with_index do |sub_taxonomy, index|
                      #                         if index == 0
                      #                             skill_count = 0
                      #                             sub_taxonomy['Skills'].each_with_index do |skills, index|
                      #                               skill_count = index+1
                      #                             end
                      #                             td rowspan: "#{skill_count}" do 
                      #                               sub_taxonomy['SubTaxonomyName']
                      #                             end
                      #                             sub_taxonomy['Skills'].each_with_index do |skills, index|
                      #                                 if index == 0
                      #                                   td do 
                      #                                     skills['Name']
                      #                                   end
                      #                                 else
                      #                                   tr do
                      #                                     td do  
                      #                                       skills['Name']
                      #                                     end
                      #                                   end
                      #                                 end
                      #                             end
                      #                         else
                      #                             skill_count = 0
                      #                             sub_taxonomy['Skills'].each_with_index do |skills, index|
                      #                                 skill_count = index+1
                      #                             end
                      #                             tr do 
                      #                                 td rowspan: "#{skill_count}" do 
                      #                                   sub_taxonomy['SubTaxonomyName']
                      #                                 end
                      #                                 sub_taxonomy['Skills'].each_with_index do |skills, index|
                      #                                     if index == 0
                      #                                       td do 
                      #                                         skills['Name']
                      #                                       end
                      #                                     else
                      #                                       tr do 
                      #                                         td do
                      #                                           skills['Name']
                      #                                         end
                      #                                       end
                      #                                     end
                      #                                 end
                      #                             end
                      #                         end
                      #                     end
                      #                 else
                      #                     tr do 
                      #                         td rowspan: "#{@span[index][index]}" do
                      #                           taxonomy['Name']
                      #                         end
                      #                         taxonomy['SubTaxonomies'].each_with_index do |sub_taxonomy, index|
                      #                             if index == 0
                      #                               skill_count = 0
                      #                                 sub_taxonomy['Skills'].each_with_index do |skills, index|
                      #                                   skill_count = index+1
                      #                                 end
                      #                                 td rowspan: "#{skill_count}" do
                      #                                   sub_taxonomy['SubTaxonomyName']
                      #                                 end
                      #                                 sub_taxonomy['Skills'].each_with_index do |skills, index|
                      #                                   if index == 0
                      #                                     td do 
                      #                                       skills['Name']
                      #                                     end
                      #                                   else
                      #                                     tr do 
                      #                                       td do 
                      #                                         skills['Name']
                      #                                       end
                      #                                     end
                      #                                   end
                      #                                 end
                      #                             else
                      #                               skill_count = 0
                      #                                 sub_taxonomy['Skills'].each_with_index do |skills, index|
                      #                                   skill_count = index+1
                      #                                 end
                      #                                 tr do 
                      #                                   td rowspan: "#{skill_count}" do 
                      #                                     sub_taxonomy['SubTaxonomyName']
                      #                                   end
                      #                                     sub_taxonomy['Skills'].each_with_index do |skills, index|
                      #                                       if index == 0
                      #                                         td do 
                      #                                           skills['Name']
                      #                                         end
                      #                                       else
                      #                                         tr do 
                      #                                           td do 
                      #                                             skills['Name']
                      #                                           end
                      #                                         end
                      #                                       end
                      #                                     end
                      #                                 end
                      #                             end
                      #                         end
                      #                     end
                      #                 end
                      #             end
                      #         end
                      #     end
                      # end
                  end
                  div style: 'overflow: auto;' do 
                    pre do 
                      @jd_data['Value']['ResumeData']['ResumeMetadata']['PlainText']
                    end
                  end
                else
                  table class: "job-data-table" do
                    tr do
                        td colspan: "4",align: "center" do
                          "Resume Data Not available"
                        end
                    end
                  end
                end
              end
          end
      end 
    end
    
    controller do
      def scoped_collection
          AccountBlock::Account.where(user_role: "candidate")
      end
    end
end   