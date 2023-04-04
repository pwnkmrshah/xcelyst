module BxBlockDatabase
	class TemporaryUserDatabaseSerializer < BuilderBase::BaseSerializer

		attributes *[
			:full_name,
			:title,
			:zipcode,
			:city,
			:status,
			:ready_to_move,
			:name,
			:location,
		  :experience,
		  :company,
		  :previous_work,
			:skills,
		  :degree,
		  :lead_lists,
			:created_at,
			:updated_at,
			:photo_url,
			:contacts,
			:social_url,
			:position,
			:summary
		]

		attributes :temporary_user_profile do |obj|
			obj.temporary_user_profile
		end

		attributes :job_projects do |obj|
			job_projects = obj.job_projects
			if job_projects.present? && job_projects.slice(0..1).include?("[{")
				job_projects = job_projects.gsub(/"(\w+)"=>/, '"\1":')
				JSON.parse(job_projects) if job_projects.present?
			else
				job_projects
			end

		end

		attributes :total_pdf_downloads do |obj|
			obj.download_pdfs.count
		end
	
		attributes :watched_records do |obj, params|
			WatchedRecord.where(temporary_user_database_id: obj.id, ip_address: params[:ip_address]).present?
		end
	end
end
