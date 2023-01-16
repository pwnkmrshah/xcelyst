module BxBlockAdmin
  class AdminUserSerializer < BuilderBase::BaseSerializer

    attributes *[
      :id,
      :email,
      :logged_in
    ]

  end
end