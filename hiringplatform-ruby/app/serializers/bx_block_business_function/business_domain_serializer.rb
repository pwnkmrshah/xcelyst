module BxBlockBusinessFunction
	class BusinessDomainSerializer < BuilderBase::BaseSerializer
		attributes *[
			:id,
			:name, 
		]
		
		attribute :category do |object|
			object.business_categories && object.business_categories.map do |category|
				{
					name: category.name,
					sub_categories: sub_categories(category.business_sub_categories)
				}
			end
		end

		class << self
			private
			
			def sub_categories(sub_categories)
				arr = []
				sub_categories && sub_categories.map do |sub_category|
					arr << {name: sub_category.name}
				end
				arr
			end
		
		end
	end
end
  