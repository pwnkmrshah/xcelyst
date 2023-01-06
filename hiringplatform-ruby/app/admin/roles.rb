ActiveAdmin.register BxBlockRolesPermissions::Role, as: "Final Feedback" do
  menu label: "Final Feedback"
  permit_params :name, :account_id, :managers, :position
  actions :all, except: [:edit, :update, :destroy, :new]

  index do
    id_column
    column :name
    column :position
    column :client_name do |obj|
      "#{obj.account.first_name} #{obj.account.last_name}"
    end
    actions
  end

  filter :name
  filter :account, label: "Clinet", :as => :select, :collection => proc { AccountBlock::Account.where(user_role: "client").collect { |d| [d.first_name, d.id] } }

  show do
    attributes_table do
      row :name
      row "Client" do |obj|
        "#{obj.account.first_name} #{obj.account.last_name}"
      end
    end
    applied_jobs = BxBlockRolesPermissions::AppliedJob.where(role_id: resource.id)
    select_applied_jobs = applied_jobs && applied_jobs.select do |a|
      if a.shortlisting_candidate.present?
        a.shortlisting_candidate.is_shortlisted
      end
    end
    panel "Applied Candidate" do
      table_for select_applied_jobs do
        if select_applied_jobs.present?
          column :user_id do |obj|
            obj.profile.account_id
          end
          column :applied_id do |obj|
            obj.id
          end
          column :candidate do |obj|
            "#{obj.profile.account.first_name} #{obj.profile.account.last_name}"
          end
          column :email do |obj|
            obj.profile.account.email
          end
          column :initial_score do |obj|
            obj&.shortlisting_candidate&.sovren_score
          end
          column :status do |obj|
            obj.status
          end
          column :accepted
          column :final_score
          column :final_feedback
          column :actions do |obj|
            span link_to "Edit", "/admin/applied_jobs/#{obj.id}/edit", class: "member_link"
          end
        end
      end
    end
  end
end
