module BxBlockInformation
	class Gdpr < ApplicationRecord
		self.table_name = :gdprs

		validates_presence_of :description
		
	end
end
