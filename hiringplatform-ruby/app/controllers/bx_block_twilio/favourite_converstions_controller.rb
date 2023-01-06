module BxBlockTwilio
    class FavouriteConverstionsController < ApplicationController
    before_action :get_favourite_converstions, only: [:create]

    def create  
      return render json: {errors: "User not a participants in conversation"} unless ChatTwilio.new().check_participant(params[:conversation_sid], current_user).success?
      begin
        favoruite = current_user.favourite_converstions.create!(sid: params[:conversation_sid])
        render json: {favoruite: favoruite}, status: :ok
      rescue => exception
        render json: {errors: exception}, status: :unprocessable_entity
      end
    end

    def show
      render json: {favoruite: current_user.favourite_converstions}, status: :ok
    end

    private

    def get_favourite_converstions
      favoruite = current_user.favourite_converstions.find_by(sid: params[:conversation_sid])
      if favoruite.present?
        render json: {message: "favoruite has been removed"} if favoruite.destroy
      end
    end

  end
end