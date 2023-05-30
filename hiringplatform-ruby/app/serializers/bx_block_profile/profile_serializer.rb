module BxBlockProfile
  class ProfileSerializer < BuilderBase::BaseSerializer
    attributes *[
      :photo,
      :full_name,
      :first_name,
      :last_name,
      :current_city,
      :phone_number,
      :email,
      :preferred_role_ids,
      :other_details,
      :cv_update,
      :currency,
    ]

    attribute :account_id do |object|
      object.account.id
    end

    attribute :currency do |object|
      object.currency
    end

    attribute :first_name do |object|
      object.account.first_name
    end
    attribute :last_name do |object|
      object.account.last_name
    end

    attribute :photo do |obj|
      if obj.account.avatar.attached?
        host = Rails.application.routes.default_url_options[:host]
        host+Rails.application.routes.url_helpers.rails_blob_url(obj.account.avatar, only_path: true)
      end
    end

    attribute :full_name do |object|
      object.account.full_name ? object.account.full_name : object.account.first_name + " " + object.account.last_name
    end

    attribute :current_city do |object|
      object.account.current_city
    end

    attribute :phone_number do |object|
      object.account.phone_number
    end

    attribute :email do |object|
      object.account.email
    end

    attributes :resume do |obj|
      host = Rails.application.routes.default_url_options[:host]
      
      if obj.account.resume_image.attached?
        host+Rails.application.routes.url_helpers.rails_blob_url(obj.account.resume_image, only_path: true)
      end
    end

    attributes :avatar do |obj|
      account = obj.account
      if account.avatar.attached?
        host = Rails.application.routes.default_url_options[:host]
        host+Rails.application.routes.url_helpers.rails_blob_url(account.avatar, only_path: true)
      end
    end

    attribute :other_details do |object|
      {
        current_compensation: object.current_compensation,
        expected_compensation: object.expected_compensation,
        notice_period: object.notice_period,
        location_preference: object.location_preference
      }
    end

    attribute :cv_update do |object|
      object&.account&.user_resume&.updated_at 
    end
  end
end
