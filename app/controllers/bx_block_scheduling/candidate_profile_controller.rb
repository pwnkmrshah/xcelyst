module BxBlockScheduling
  class CandidateProfileController < ApplicationController
		before_action :current_user, only: :profile
		before_action :check_user_role, only: :profile

		# Create by Punit 
		# Show the Candidate Details or Role Details to Client
		def profile
			candidate = AccountBlock::Account.find(params[:user_id])
			role = BxBlockRolesPermissions::Role.find(params[:role_id])
			render json: CandidateProfileSerializer.new(candidate, params: { user: @current_user, role: role }).serializable_hash, status: 200
		end 	

	end
end
