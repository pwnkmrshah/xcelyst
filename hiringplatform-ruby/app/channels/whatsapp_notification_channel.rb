class WhatsappNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "whatsapp_notifications"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
