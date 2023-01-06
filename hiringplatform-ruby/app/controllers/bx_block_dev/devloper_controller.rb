module BxBlockDev
    class DevloperController < ApplicationController
      
        def create_account
            account_params = jsonapi_deserialize(params)
            account = AccountBlock::Account.create(jsonapi_deserialize(params))
            account.activated = true
            if account.save
                render json: {account: account}, status: :created
            else
                render json: {errors: account.errors}, status: :unprocessable_entity
            end
        end

    end
  end
  