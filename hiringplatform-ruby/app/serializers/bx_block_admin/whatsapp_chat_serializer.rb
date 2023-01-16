module BxBlockAdmin
  class WhatsappChatSerializer < BuilderBase::BaseSerializer

  attribute :chat_id do |obj|
    obj.id
  end

  attributes :user_name do |obj|
    user(obj)
    "#{@user&.first_name} #{@user&.last_name}"
  end

  attributes :user_type do |obj|
   @user.class.name
  end
 
  attributes :email do |obj|
    @user.email
  end

  attributes :phone_number do |obj|
    @user.has_attribute?(:phone_no) ? @user&.phone_no : @user&.phone_number
  end

  attribute :photo do |obj|
    if obj.user.class.name == "AccountBlock::Account" || obj.user.class.name == "AccountBlock::EmailAccount" && obj.user.avatar.attached?
      host = Rails.application.routes.default_url_options[:host]
      host + Rails.application.routes.url_helpers.rails_blob_url(obj.user.avatar, only_path: true)
    end
  end

  private
    class << self
      
      def user(obj)
        @user = obj.user
      end
    end

  end
end