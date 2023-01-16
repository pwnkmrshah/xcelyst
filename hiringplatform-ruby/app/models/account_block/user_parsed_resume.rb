module AccountBlock
	class UserParsedResume
    include Mongoid::Document

    field :user_resume_id, type: BigDecimal
    field :account_id, type: BigDecimal
    field :parsed_resume, type: Hash
    
	end
end
