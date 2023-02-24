ActiveAdmin.register AccountBlock::Account, as: "AI Macthing" do
  menu label: "AI Macthing", priority: 6, if: proc { current_admin_user.present? && current_admin_user.can_read_account_block_for_ai_matching?(current_admin_user) }
  config.paginate = false
  config.filters = false

  actions :all, :except => [:destroy, :new, :edit]

  # permit_params :client_id, :job_description_id

  index pagination_total: false, :download_links => false, :class => "pagination_ai" do
    @clients_account = AccountBlock::Account.where(user_role: "client")
    form do |f|
      div class: "align-dropdown" do
        div do
          f.label do
            "Select Client"
          end
          f.select id: "ai_client_dropdown" do
            options_for_select(@clients_account.map { |c| [c.first_name, c.id] }, { include_blank: true })
          end
        end
        div do
          f.label do
            "Select Job Description"
          end
          f.select id: "ai_jb_dropdown" do
            role_ids = BxBlockRolesPermissions::Role.where(account_id: @clients_account.first.id).ids
            options_for_select(BxBlockJobDescription::JobDescription.where(role_id: role_ids).map { |c| [c.job_title, c.id] })
          end
        end
        # div do
        #   f.button class: "button", id: "shortlist_ajax" do
        #     "shortlist"
        #   end
        # end
        div do
          link_to "Ai Matching", "#", class: "button disabled", id: "ai_matching", target: "_blank"
        end
      end
    end
    # selectable_column
    # id_column
    # column :first_name
    # column :last_name
    # column :email
    # actions
  end

  controller do
    def index
      @page_title = "AI Macthing"
    end
  end
end
