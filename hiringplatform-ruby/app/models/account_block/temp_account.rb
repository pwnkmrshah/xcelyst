module AccountBlock
	class TempAccount
    include Mongoid::Document

    field :temporary_account_id, type: BigDecimal
    field :parsed_resume, type: Hash
    
	end
end
