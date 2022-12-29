module BxBlockTwilio
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token

    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    private

    def not_found
      render :json => {'errors' => ['Record not found']}, :status => :not_found
    end

    def current_user
      if request.headers[:token] || params[:token]
        validate_json_web_token
        if @token.id.present?
          @current_user = AccountBlock::Account.find(@token.id)
        elsif @token.admin_id.present?
          @current_user = AccountBlock::Account.find(params[:client_id])
        end
      end
    end

  end
end
