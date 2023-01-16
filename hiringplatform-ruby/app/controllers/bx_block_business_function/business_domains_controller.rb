module BxBlockBusinessFunction
	class BusinessDomainsController < BuilderBase::ApplicationController

		# created by punit
		# send veritcals page content.
		def show
			business_doamin = BxBlockBusinessFunction::BusinessDomain.all
			if business_doamin.length > 0 
				render json: BusinessDomainSerializer.new(business_doamin).serializable_hash, status: :ok
			else
				render json: {message: "data not found"}, status: :unprocessable_entity
			end
		end
		
	end
end
  