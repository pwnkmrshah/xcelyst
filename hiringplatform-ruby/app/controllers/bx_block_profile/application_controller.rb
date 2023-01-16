module BxBlockProfile
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    # before_action :validate_json_web_token, except: [:recommended_roles]
    # serialization_scope :view_context

    private

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

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end
  end
end
