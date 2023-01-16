module BxBlockInformation
	class PrivacyPolicy < ApplicationRecord
		self.table_name = :privacy_policy_informations

		validates_presence_of :description
		
	end
end
