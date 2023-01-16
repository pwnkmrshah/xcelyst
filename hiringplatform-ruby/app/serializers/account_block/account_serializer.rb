module AccountBlock
  class AccountSerializer < BuilderBase::BaseSerializer
    attributes *[
      :activated,
      :country_code,
      :email,
      :first_name,
      :full_phone_number,
      :last_name,
      :phone_number,
      :type,
      :created_at,
      :updated_at,
      :device_id,
      :unique_auth_id,
      :resume_url,
      :current_city,
      :cover_letter_url,
      :photo,
      :document_id,
      :is_converted_account
    ]

    attribute :country_code do |object|
      country_code_for object
    end

    attribute :phone_number do |object|
      phone_number_for object
    end

    attribute :photo do |obj|
      if obj.avatar.attached?
        host = Rails.application.routes.default_url_options[:host]
        host+Rails.application.routes.url_helpers.rails_blob_url(obj.avatar, only_path: true)
      end
    end

    class << self
      private

      def country_code_for(object)
        return nil unless Phonelib.valid?(object.full_phone_number)
        Phonelib.parse(object.full_phone_number).country_code
      end

      def phone_number_for(object)
        return nil unless Phonelib.valid?(object.full_phone_number)
        Phonelib.parse(object.full_phone_number).raw_national
      end
    end
  end
end
