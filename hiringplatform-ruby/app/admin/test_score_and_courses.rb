ActiveAdmin.register BxBlockProfile::TestScoreAndCourse, as: "Test Score And Course" do
    menu false
    permit_params :title, :test_date, :test_url, role_ids: []

    index do
        id_column
        column :title
        column :test_date
        actions
    end
    
      filter :title
      
    show do
      attributes_table do
        row :test_id
        row :title
        row :description
        row :score
        row :test_url
      end
      ids = resource.role_ids
      roles = BxBlockRolesPermissions::Role.where(id: ids)
      panel "Roles" do
        table_for roles do
          column :name
          column :client_name do |obj|
            obj.account.user_full_name
          end
          column :clinet_email do |obj|
            obj.account.email
          end
        end
      end
    end
    
      form do |f|
        role_ids = BxBlockRolesPermissions::AppliedJob.where(profile_id: resource.account&.profile&.id).pluck(:role_id)
        f.inputs do
          f.input :title,input_html: { readonly: true, disabled: true }
          f.input :test_id,input_html: { readonly: true, disabled: true }
          f.input :test_url
          f.input :role_ids, as: :select, collection: BxBlockRolesPermissions::Role.where(id: role_ids), input_html: { multiple: true }
        end
        f.actions do |obj|
          f.action :submit
          f.cancel_link "/admin/test_accounts/#{resource.account.id}"
        end
      end
    
      controller do
        before_update :update_params 

        def update
          super do |success, failure|
            success.html { redirect_to "/admin/test_accounts/#{resource.account.id}" }
            failure.html { redirect_to "/admin/test_accounts/#{resource.account.id}" }
          end
        end

        def update_params resource
          ids = resource.role_ids.compact
          resource.update(role_ids: ids)
        end
      end
  end
  