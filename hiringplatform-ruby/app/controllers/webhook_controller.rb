class WebhookController < ApplicationController

  def permisssion_enalbed
  	module_name = params[:module_name]
    permisssion_enalbed = current_user_admin.batch_action_permission_enabled?(module_name.singularize.humanize.downcase) if module_name.present?
	render json: {success: permisssion_enalbed, message: 'Enabled'}
  end

	# Create by Punit
	# Webhook Method for Verify Webhook Url when we attach on WhatSapp, this is one time call Method
	def whatsapp
		verify_token = "hiring_platform";
		mode = params["hub.mode"]
		token = params["hub.verify_token"]
		challenge = params["hub.challenge"]

		# Check if a token and mode were sent
		if mode && token 
			if	(mode === "subscribe" && token === verify_token)
				return render json: challenge, status: 200
			else
				render json: {}, status: 403 
			end
		end
	end


	# Create by Punit
	# Receives Message Data when Candidate Send a Message on Whatsapp to us 
	# save message in database and broadcast the message or notification to front end.
	def receive_request
		changes = params["entry"][0]["changes"]
		if changes[0]["field"] == "messages"
			changes[0]["value"]["messages"].present? && changes[0]["value"]["messages"].map do |message|
				user = AccountBlock::TemporaryAccount.find_by(phone_no: "+#{message["from"]}") || AccountBlock::TemporaryAccount.find_by(phone_no: "#{message["from"]}") || AccountBlock::Account.find_by(phone_number: "+#{message["from"]}") || AccountBlock::Account.find_by(phone_number: "#{message["from"]}")
				if user.present?
					chat = BxBlockWhatsapp::WhatsappChat.find_or_create_by(
						user_id: user.id,
						user_type: user.class.name,
						admin_user_id: UserAdmin.first.id
					)
					messages = BxBlockWhatsapp::WhatsappMessage.create(
						whatsapp_chat_id: chat.id,
						message: message["text"]["body"],
						sender_type: user.class.name,
						sender_id: user.id,
						receiver_type: "UserAdmin",
						receiver_id: UserAdmin.first.id
					)
					if chat.whatsapp_messages.count == 1
						ActionCable.server.broadcast("whatsapp_new_chat", BxBlockAdmin::WhatsappChatSerializer.new(chat))
					end
					ActionCable.server.broadcast("whatsapp_chat_#{chat.id}", BxBlockAdmin::WhatsappMessageSerializer.new(messages))
					ActionCable.server.broadcast("whatsapp_notifications", BxBlockAdmin::WhatsappChatSerializer.new(chat))
					render json: {message: "message received successfuly"}, status: 200
				else
					render json: {message: "user not found"}, status: 200
				end
			end
		end

	end

end
