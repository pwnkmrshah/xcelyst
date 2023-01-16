module BxBlockDatabase
	class WatchedRecordsController < ApplicationController

		before_action :find_temp_user_db, only: :create

		def create
			wat_rec = WatchedRecord.find_or_initialize_by(temporary_user_database_id: @temp_user_db.id, ip_address: params[:ip_address])
			if wat_rec.save 
				render json: { message: "Record has been watched." }, status: 200
			else
				render json: { errors: wat_rec.errors.full_messages }, status: :unprocessable_entity
			end
		end

		private 

		def find_temp_user_db
			@temp_user_db = TemporaryUserDatabase.find(params[:temporary_user_database_id])
		end

	end
end
