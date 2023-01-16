module BxBlockPreferredRole
	class PreferredSkill < ApplicationRecord
		self.table_name = :preferred_skills

		has_many :user_preferred_skills, class_name: "AccountBlock::UserPreferredSkill"
		
		validates_uniqueness_of :name, presence: true


		 
	end
end
