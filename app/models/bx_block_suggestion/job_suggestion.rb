module BxBlockSuggestion
	class JobSuggestion < BxBlockSuggestion::ApplicationRecord
		self.table_name = :jobs_suggestions
	end
end
