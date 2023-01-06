module AccountBlock
  class EmailAccountSerializer
    include FastJsonapi::ObjectSerializer

    attributes *[
      :first_name,
      :last_name,
      :email,
      :current_city,
      :user_role,
      :resume_url,
      :cover_letter_url,
      :activated,
      :photo,
      :document_id,
      :is_converted_account
    ]

    attributes :resume do |obj|
      host = Rails.application.routes.default_url_options[:host]
      
      if obj.resume_image.attached?
        host+Rails.application.routes.url_helpers.rails_blob_url(obj.resume_image, only_path: true)
      end
    end

    attributes :full_name do |obj|
      "#{obj.first_name} #{obj.last_name}"
    end

    attributes :photo do |obj|
      host = Rails.application.routes.default_url_options[:host]

      if obj.avatar.attached?
        host+Rails.application.routes.url_helpers.rails_blob_url(obj.avatar, only_path: true)
      end
    end

  end
end
