module BxBlockJobDescription
	class JobDescriptionSerializer
		include FastJsonapi::ObjectSerializer

		attributes *[
            :id,
            :name,
            :categories
        ]

		attribute :categories do |object|
         	object.domain_category && object.domain_category.map do |category|
				{
					category_id: category.id,
					category_name: category.name,
					skilles: specific_skill(category)
				}
			end
  		end
	class << self

		private

			def specific_skill(category)
				arr = []
				category.domain_sub_category && category.domain_sub_category.map do |ab|
					hash = {id: ab.id, name: ab.name}
					arr << hash
				end
				arr
			end
	end

	end
end
  
