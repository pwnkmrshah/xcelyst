module BxBlockSuggestion
	class JobSuggestionsController < ApplicationController

		def show
			if params[:name].present?
			 	@job_suggestion = JobSuggestion.where('suggestion LIKE ?', "%#{params[:name]}%")
			 	render json: @job_suggestion, status: :ok
			else
				render json: {error: "something wrong"},status: 400
			end
		end
	end
end
