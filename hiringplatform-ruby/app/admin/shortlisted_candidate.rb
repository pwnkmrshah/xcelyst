ActiveAdmin.register BxBlockShortlisting::ShortlistingCandidate, as: "Shortlisted Candidate" do
  menu label: "Shortlisted Candidate"
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('shortlisted candidate') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

  actions :index, :show, :destroy

  scope :shortlisted
  scope :applied_by_candidate

  index do
    selectable_column
    id_column
    column :job_title do |obj|
      if obj.job_description.present?
        link_to obj.job_description.job_title, admin_job_description_path(obj.job_description_id)
      end
    end
    column :client_name do |obj|
      if obj.client.present?
        link_to obj.client.first_name, admin_client_path(obj.client)
      end
    end
    column :candidate_name do |obj|
      if obj.candidate.present?
        link_to obj.candidate.first_name, admin_candidate_path(obj.candidate)
      end
    end
    tag_column :shortlisted_by_admin, interactive: true
    column :is_applied_by_candidate
    column :sovren_score
    actions
  end

  filter :job_description, :as => :select, :collection => proc { BxBlockJobDescription::JobDescription.all.collect {|o| [o.job_title, o.id]} }
  filter :client, :as => :select, :collection => proc { AccountBlock::Account.where(user_role: "client").collect{|d| [d.first_name, d.id]} }
  filter :candidate, :as => :select, :collection => proc { AccountBlock::Account.where(user_role: "candidate").collect{|d| [d.first_name, d.id]} }

  show do
    attributes_table do
      row :job_title do |obj|
        if obj.job_description.present?
          obj.job_description.job_title
        end
      end
      row :client_name do |obj|
        if obj.client.present?
          obj.client.first_name
        end
      end
      row :candidate_name do |obj|
        if obj.candidate.present?
          obj.candidate.first_name
        end
      end
      row :sovren_score
      row :created_at
      row :updated_at
    end
  end

  controller do
    def update
      if request.xhr?
        shortlisted = BxBlockShortlisting::ShortlistingCandidate.find_by(id: params[:id])
        candidate = AccountBlock::Account.find(shortlisted.candidate_id)
        jd = BxBlockJobDescription::JobDescription.find(shortlisted.job_description_id)
        BxBlockRolesPermissions::AppliedJob.find_or_create_by(profile_id: candidate.profile.id, role_id: jd.role.id, shortlisting_candidate_id: shortlisted.id)
        if params[:bx_block_shortlisting_shortlisting_candidate][:shortlisted_by_admin]
          shortlisted.update_attributes(shortlisted_by_admin: params[:bx_block_shortlisting_shortlisting_candidate][:shortlisted_by_admin], is_shortlisted: true)
        else
          shortlisted.update_attributes(shortlisted_by_admin: params[:bx_block_shortlisting_shortlisting_candidate][:shortlisted_by_admin])
        end
      else
        update! { |success, failure|
          success.html do
            redirect_to admin_shortlisting_candidate_path(resource)
          end
        }
      end
    end
  end
end
