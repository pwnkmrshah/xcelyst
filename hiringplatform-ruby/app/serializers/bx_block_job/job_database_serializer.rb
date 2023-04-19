module BxBlockJob
	class JobDatabaseSerializer < BuilderBase::BaseSerializer

		attributes *[
			:id,
			:url,
			:company_uid,
      :company_name,
			:company_logo,
			:job_uid,
			:job_title,
			:location,
			:date_published,
			:business_area,
			:area_domain,
			:reference_code,
			:employment,
			:responsibilities,
			:skills,
			:apply_for_job_url,
			:description,
			:created_at,
			:updated_at
		]
	end
end
