module BxBlockInformation
	class GdprsController < ApplicationController

		def index
  		@policy = Gdpr.all
  		if @policy.present?
  			render json: GdprSerializer.new(@policy), status: 200
  		else
  			render json: { message: "No policy found" }, status: 200
  		end
  	end

	end
end
