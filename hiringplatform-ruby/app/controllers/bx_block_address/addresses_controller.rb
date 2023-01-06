module BxBlockAddress
  class AddressesController < ApplicationController
    before_action :get_account, only: [:index, :create]

    def index
      @account_addresses = Address.where(addressble_id: @account.id)
      render json: {
        message: 'No Address is present'
      } and return unless @account_addresses.present?
      render json: BxBlockAddress::AddressSerializer.new(
        @account_addresses, meta: {message: 'List of all addresses'}
      ).serializable_hash
    end

    def create
      full_params = address_params.merge( { addressble_id: @account.id } )
      @address = Address.new(full_params)
      if @address.save
        render json: BxBlockAddress::AddressSerializer.new(@address, meta: {
          message: 'Address Created Successfully',
        }).serializable_hash, status: :created
      else
        render json: { errors: format_activerecord_errors(@address.errors) },
               status: :unprocessable_entity
      end
    end

    private

    def address_params
      params.require(:address).permit(:latitude, :longitude, :address, :address_type)
    end
    def get_account
      @account = AccountBlock::Account.find(@token.id)
    end
  end
end
