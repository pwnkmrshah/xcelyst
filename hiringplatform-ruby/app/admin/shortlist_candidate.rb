ActiveAdmin.register AccountBlock::Account, as: "Shortlist Candidate" do
  menu label: "Shortlist Candidate", if: proc { current_user_admin.present? && current_user_admin.can_read_account_block_for_shortlist_candidate?(current_user_admin) }  
  permit_params :client_id, :job_description_id
  actions :index, :destroy
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('shortlist candidate') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

  index do
    render partial: 'admin/candidate'
    @clients_account = AccountBlock::Account.where(user_role: "client")
    form do |f|
      div class: "align-dropdown" do
        div do
          f.label do
            "Select Client"
          end
          f.select id: "client_dropdown" do
            options_for_select(@clients_account.map { |c| [c.first_name, c.id] }, { include_blank: true })
          end
        end
        div do
          f.label do
            "Select Job Description"
          end
          f.select id: "jd_dropdown" do
            role_ids = BxBlockRolesPermissions::Role.where(account_id: @clients_account.first.id).ids
            options_for_select(BxBlockJobDescription::JobDescription.where(role_id: role_ids).map { |c| [c.role.name, c.id] })
          end
        end
        div do
          f.button class: "button", id: "shortlist_ajax" do
            "shortlist"
          end
        end
        # div do
        #   link_to "Ai Matching", "#", class: "button disabled", id: "ai_matching", target: "_blank"
        # end
      end
    end
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :document_id do |obj|
      obj&.user_resume&.document_id
    end
    actions
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :document_id
  # filter :"document_id" , :as => :select, :collection => AccountBlock::UserResume.all.map(&:document_id)
  # filter :user_resume

  controller do
    def scoped_collection
      AccountBlock::Account.where(user_role: "candidate")
    end

    def batch_action
      begin
        scoped_collection.where(id:params[:collection_selection]).destroy_all
        redirect_to admin_shortlist_candidates_path, notice: 'Accounts deleted successfully.'
      rescue StandardError => e
        redirect_to admin_shortlist_candidates_path, notice: e.message
      end
    end
  end
end
