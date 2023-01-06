ActiveAdmin.register BxBlockRolesPermissions::AppliedJob, as: "Applied Job" do
  menu label: "Rejected Candidate"
  permit_params :id, :profile_id, :role_id, :shortlisting_candidate_id, :final_score, :accepted, :final_feedback
  actions :index, :show, :edit, :update

  index do
    selectable_column
    id_column
    column :candidate do |obj|
      obj.profile.account.first_name + " " + obj.profile.account.last_name
    end
    column :email do |obj|
      obj.profile.account.email
    end
    column :client do |obj|
      obj.role.account.first_name
    end
    column :role do |obj|
      obj.role.name
    end
    column :final_score do |obj|
      obj.final_score || "-"
    end
    column :final_feedback do |obj|
      obj.final_feedback || "-"
    end
    column :accepted
    column :status
  end

  filter :role, :as => :select, :collection => proc { BxBlockRolesPermissions::Role.all.collect { |o| [o.name, o.id] } }

  form do |f|
    panel "Applied Candidate" do
      attributes_table_for resource do
        row :user_id do |obj|
          obj.profile.account_id
        end
        row :applied_id do |obj|
          obj.id
        end
        row :candidate do |obj|
          "#{obj.profile.account.first_name} #{obj.profile.account.last_name}"
        end
        row :email do |obj|
          obj.profile.account.email
        end
        row :initial_score do |obj|
          obj&.shortlisting_candidate&.sovren_score
        end
        row :status do |obj|
          obj.status
        end
      end
    end
    f.inputs do
      f.input :final_score
      f.input :final_feedback
    end
    f.actions do |obj|
      f.action :submit
      f.cancel_link "/admin/final_feedbacks/#{resource.role_id}"
    end
  end

  controller do
    def update
      super do |success, failure|
        success.html { redirect_to "/admin/final_feedbacks/#{resource.role_id}" }
      end
    end

    def scoped_collection
      if ["index"].include?(params[:action])
        BxBlockRolesPermissions::AppliedJob.where(status: "rejected")
      else
        super
      end
    end
  end
end
