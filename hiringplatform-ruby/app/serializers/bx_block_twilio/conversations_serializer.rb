module BxBlockTwilio
  class ConversationsSerializer < BuilderBase::BaseSerializer
    attributes *[
      :conversation_sid,
      :unique_name,
      :friendly_name,
      :url,
      :client_sid,
      :candidate_sid
  ]


    attribute :candidate_name do |obj|
      obj.candidate.user_full_name
    end

    attribute :candidate_photo do |obj|
        if obj.candidate.avatar.attached?
          host = Rails.application.routes.default_url_options[:host]
          host+Rails.application.routes.url_helpers.rails_blob_url(obj.candidate.avatar, only_path: true)
        end
    end
    
    attribute :client_photo do |obj|
        if obj.client.avatar.attached?
          host = Rails.application.routes.default_url_options[:host]
          host+Rails.application.routes.url_helpers.rails_blob_url(obj.client.avatar, only_path: true)
        end
    end

    attribute :client_name do |obj|
      obj.client.user_full_name
    end
  end
end