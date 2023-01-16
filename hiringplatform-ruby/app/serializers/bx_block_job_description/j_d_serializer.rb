module BxBlockJobDescription
	class JDSerializer
		include FastJsonapi::ObjectSerializer

		attributes *[
			:id, 
			:job_title, 
			:role_title, 
			:preferred_overall_experience,
			:minimum_salary, 
			:location, 
			:company_description, 
			:job_responsibility,
			:role, 
			:currency
		]

	end
end
  
