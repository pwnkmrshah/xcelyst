class WhatsappChatChannel < ApplicationCable::Channel
  def subscribed
    chat = BxBlockWhatsapp::WhatsappChat.find_by(id: params[:chat_id])
    if chat.present?
      stop_all_streams
      stream_from "whatsapp_chat_#{chat.id}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end



