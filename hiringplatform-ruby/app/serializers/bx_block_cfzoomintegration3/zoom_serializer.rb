module BxBlockCfzoomintegration3
  class ZoomSerializer < BuilderBase::BaseSerializer
    include FastJsonapi::ObjectSerializer

    attribute *[
      :id,
      :zoom_user_id,
      :first_name,
      :last_name,
      :email,
      :status
    ]

  end
end
