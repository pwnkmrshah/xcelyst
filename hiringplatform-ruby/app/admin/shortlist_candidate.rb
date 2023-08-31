ActiveAdmin.register AccountBlock::Account, as: "Shortlist Candidate" do
  menu label: "Shortlist Candidate", if: proc { current_user_admin.present? && current_user_admin.can_read_account_block_for_shortlist_candidate?(current_user_admin) }  
  permit_params :client_id, :job_description_id
  actions :index

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
  end
end
