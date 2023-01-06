module BxBlockSovren
	class BulkUploadsController < ApplicationController

		skip_before_action :validate_json_web_token, only: :sample_resume_parser

		def resume
			x = BxBlockBulkUpload::ResumeUpload.execute(params[:resumes])
			if x.count > 0
        return render json: { message: 'Done' }, status: 200
      else
        return render json: { errors: "There might be something wrong." }, status: :unprocessable_entity
      end
		end

		def sample_resume_parser
			x = BxBlockSovren::SampleParsingApi.new(params[:file]).execute
			render json: { data: x }, status: 200
		end

	end
end
