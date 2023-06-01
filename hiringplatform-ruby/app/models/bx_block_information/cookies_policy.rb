module BxBlockInformation
	class CookiesPolicy < ApplicationRecord
		self.table_name = :cookies_policies

		validates_presence_of :description
		
	end
end
