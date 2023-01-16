module BxBlockInformation
	class TermCondition < ApplicationRecord
		self.table_name = :term_conditions

		validates_presence_of :description
		
	end
end
