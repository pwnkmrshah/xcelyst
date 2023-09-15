module BxBlockLogin
  class LoginsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    def create
      case params[:data][:type] #### rescue invalid API format
      when 'sms_account', 'email_account', 'social_account'
        account = OpenStruct.new(jsonapi_deserialize(params))
        account.type = params[:data][:type]

        output = AccountAdapter.new

        output.on(:account_not_found) do |account|
          render json: {
            errors: [{
              failed_login: 'Account not found',
            }],
          }, status: :unprocessable_entity
        end

        output.on(:not_fully_verify) do |account, token|
          return render json: {
            errors: [{
              failed_login: 'not_fully_verify',
              }],
              meta: { token: token }
          }, status: 200
        end

        output.on(:failed_login) do |account|
          render json: {
            errors: [{
              failed_login: 'Incorrect Email OR Password.',
            }],
          }, status: :unauthorized
        end

        output.on(:successful_login) do |account, token|
          render json: AccountBlock::EmailAccountSerializer.new(account, meta: { token: token } )
        end

        output.login_account(account)
      else
        render json: {
          errors: [{
            account: 'Invalid Account Type',
          }],
        }, status: :unprocessable_entity
      end
    end

    def client_login
      if params[:data]
        para = jsonapi_deserialize(params)
        @account = AccountBlock::Account.find_by('LOWER(email) = ? and user_role = ?', para["email"].downcase, 'client')
        render json: { errors: [{ account: 'Account not found', }],}, status: :unprocessable_entity and return if @account.nil?
        if @account.present? && @account.user_role == "client" && @account.authenticate(para["password"]) && @account.activated
          render json: AccountBlock::EmailAccountSerializer.new(@account, meta: {token: encode(@account.id)}).serializable_hash
        else
          render json: { errors: [{ account: 'Incorrect Email OR Password', }],}, status: :unprocessable_entity
        end
      else
        render json: { errors: [{ account: 'Login Failed', }],}, status: :unprocessable_entity
      end
    end
    
    private
    
    def encode(id)
      BuilderJsonWebToken.encode id, 'app_user'
    end
  end
end
