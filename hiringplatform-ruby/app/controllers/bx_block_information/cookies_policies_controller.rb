module BxBlockInformation
	class CookiesPoliciesController < ApplicationController

		def index
  		@cookies = CookiesPolicy.all
  		if @cookies.present?
  			render json: CookiesPolicySerializer.new(@cookies), status: 200
  		else
  			render json: { message: "no cookies found" }, status: 200
  		end
  	end
  	
	end
end
