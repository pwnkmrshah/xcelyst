module BxBlockCfzoomintegration3
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token

    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    private

    def not_found
      render :json => {'errors' => ['Record not found']}, :status => :not_found
    end

    def current_user
      @current_user = AccountBlock::Account.find @token.id
    end

    def check_user_role
      unless @current_user.user_role == "client"
        return render json: { error: "Only client can do this action." }, status: :unprocessable_entity
      end
    end

  end
end
