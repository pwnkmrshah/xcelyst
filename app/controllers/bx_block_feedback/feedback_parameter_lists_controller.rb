module BxBlockFeedback
  class FeedbackParameterListsController < ApplicationController

    # Create by punit
    # Send all feedback parameter create by admin
    def index
      feedback_name = FeedbackParameterList.all
      if feedback_name.length > 0
        render json: { parameters: feedback_name }, status: :ok
      else
        render json: { errors: "Data not found" }, status: :unprocessable_entity
      end
    end
  end
end