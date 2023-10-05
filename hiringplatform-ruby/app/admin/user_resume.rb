ActiveAdmin.register AccountBlock::UserResume, as: "User Resume" do
    menu false
	index do
		selectable_column
		id_column
		column :resume_id
		column :sovren_score
		column :index_id
		column :document_id
		# actions
	end
	
end