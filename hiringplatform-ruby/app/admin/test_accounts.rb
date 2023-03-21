ActiveAdmin.register AccountBlock::Account, as: "Test Account" do
    menu label: "Test Accounts", if: proc { current_user_admin.present? && current_user_admin.can_read_account_block_for_test_account?(current_user_admin) }  
    actions :index, :show

    index do
      id_column
      column :candidate_full_name do |user|
        user.user_full_name
      end
      column :email do |user|
        user.email
      end
      column :created_at
      actions
    end      

    # filter :candidate_full_name
    filter :email

    show do 
      attributes_table do
        row :id
        row :first_name
        row :last_name
        row :email
      end
      testScore = resource.test_score_and_courses
      panel "Applied Candidate" do
        table_for testScore do
          column :test_id
          column :title
          column :description
          column :score
          column :test_url
          column :status
          column :actions do |obj|
            span link_to "Edit", "/admin/test_score_and_courses/#{obj.id}/edit", class: "member_link"
            span link_to "View", "/admin/test_score_and_courses/#{obj.id}", class: "member_link"
          end
        end
      end
    end


    controller do
      def scoped_collection
        account_ids = BxBlockProfile::TestAccount.pluck(:account_id)
        AccountBlock::Account.where(id: account_ids)
      end
    end
end