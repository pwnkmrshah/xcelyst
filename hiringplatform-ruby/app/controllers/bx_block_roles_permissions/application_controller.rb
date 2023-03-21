module BxBlockRolesPermissions
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

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

    def check_client_role
      validate_json_web_token
      if @token.id.present?
        unless current_user.user_role == "client"
          return render json: { error: "Only client admin can do this action." }, status: :unprocessable_entity
        end
      elsif @token.admin_id.present?
        @admin = UserAdmin.find_by(id: @token.admin_id)
        unless @admin.present?
          return render json: { error: 'Invalid Admin User.' }, status: :unprocessable_entity
        end
      else
        return render json: { error: 'Invalid User.' }, status: :unprocessable_entity
      end
    end
  end
end
