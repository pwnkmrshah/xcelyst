module BxBlockAddress
  class LocationAddressSerializer < BuilderBase::BaseSerializer

    attributes *[
      :country,
      :address,
      :email,
      :phone,
      :order
    ]
    
  end
end
