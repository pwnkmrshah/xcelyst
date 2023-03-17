ActiveAdmin.register BxBlockManager::Manager, as: "Manager" do
  menu parent: ["Platform Users",  "Client"], label: "Hiring Manager"
  permit_params :name, :email, :account_id

  index do
    selectable_column
    id_column
    column :name
    column :email
    column "client" do |object|
      object.account.first_name + " " + object.account.last_name
    end
    actions
  end

  filter :name
  filter :email

  show do
    attributes_table do
      row :name
      row :email
      row "client" do |object|
        object.account.first_name + " " + object.account.last_name
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :account_id, as: :select, collection: AccountBlock::Account.where(user_role: "client").collect { |step| [step.first_name + " " + step.last_name, step.id] }
    end
    f.actions
  end
end
