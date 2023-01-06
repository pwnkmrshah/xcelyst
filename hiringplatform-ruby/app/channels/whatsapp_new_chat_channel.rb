class WhatsappNewChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "whatsapp_new_chat"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
