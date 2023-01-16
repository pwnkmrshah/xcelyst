module BxBlockInformation
	class PrivacyPoliciesController < ApplicationController

		def index
  		@policy = PrivacyPolicy.all
  		if @policy.present?
  			render json: PrivacyPolicySerializer.new(@policy), status: 200
  		else
  			render json: { message: "No policy found" }, status: 200
  		end
  	end

	end
end
