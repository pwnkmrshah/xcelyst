module BxBlockAdmin
  class WhatsappMessageSerializer < BuilderBase::BaseSerializer

  attribute :message_id do |obj|
    obj.id
  end

  attributes :type do |obj|
    if obj.sender.class.name == "AdminUser"
      "send"
    else
      "receiver"
    end
  end

  attributes :chat_id do |obj|
    obj.whatsapp_chat_id
  end

  attributes :message do |obj|
   obj.message
  end
 
  attribute :created_at do |obj|
    obj.created_at
  end

  end
end