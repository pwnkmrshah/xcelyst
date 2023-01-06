module BxBlockProfile
  class ClientProfileSerializer < BuilderBase::BaseSerializer

    attributes :photo do |obj|
      if obj.avatar.attached?
        host = Rails.application.routes.default_url_options[:host]
        host+Rails.application.routes.url_helpers.rails_blob_url(obj.avatar, only_path: true)
      end
    end

  end
end