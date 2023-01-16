module BxBlockInformation
  class PrivacyPolicySerializer < BuilderBase::BaseSerializer
    include JSONAPI::Serializer
    
    attributes *[
      :id,
      :title,
      :description,
      :created_at,
      :updated_at
    ]

  end
end
