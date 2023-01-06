module BxBlockInformation
	class TermConditionsController < ApplicationController

		def index
  		@terms = TermCondition.all
  		if @terms.present?
  			render json: TermConditionSerializer.new(@terms), status: 200
  		else
  			render json: { message: "no terms found" }, status: 200
  		end
  	end
  	
	end
end
