module BxBlockAdmin 
    class AdminUsersController < ApplicationController
        
        # def create
        #     user = AdminUser.find_by(email: params[:email])
        #     if user && user.valid_password?(params[:password])
        #         render json: {user: user, meta: {token: encode(user.id)}}, status: :ok
        #     else
        #         render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
        #     end
        # end

        # created by Punit 
        # get the all whatsapp chats from our database 
        def fetch_whatsapp_chats
            chats = BxBlockWhatsapp::WhatsappChat.all.by_most_recent_message.uniq
            render json: WhatsappChatSerializer.new(chats), status: :ok
        end

        # created by Punit 
        # get the all whatsapp message for a specific chat from our database 
        def fetch_whatsapp_messges
            messages = BxBlockWhatsapp::WhatsappChat.all.find_by(id: params[:chat_id]).whatsapp_messages
            render json: WhatsappMessageSerializer.new(messages), status: :ok
        end

        # Create by Punit 
        # Send the message on whatsapp and also save the message in our database 
        def send_messages
            chat = BxBlockWhatsapp::WhatsappChat.find_by(id: params[:chat_id])
            if chat.present?
                user = chat.user
                message = BxBlockWhatsapp::WhatsappMessage.create(
                    whatsapp_chat_id: chat.id,
                    message: params[:message],
                    sender_type: "AdminUser",
                    sender_id: current_user.id,
                    receiver_type: user.class.name,
                    receiver_id: user.id
                )
                phone_number = user.has_attribute?(:phone_no) ? user&.phone_no : user&.phone_number
                components = [
                    { "type": "body",  "parameters": [{ "type": "text", "text": "#{params[:message]}" }] }
                ]

                response = Faraday.send('post') do |req|
                    req.headers[:Content_Type] = 'application/json'
                    req.headers[:Authorization] = "Bearer EAAPhfZAZC73t8BAOV73aMsLwZC7mF3dagPhZByxlMzCHmSuNAFAtf3M3jm6G23DlZBXaVfsDqwFOoEZAmcSMcKyjyLrk0OtvmYYcK2MVXtZBPZAmh3jPjF08gVvZBjUaSnNCZBd5fakrcIWFSCYYqRFpazg1bIZCJBBfex9kkH2euAufKu75ib9ZBr52"
                    req.url "https://graph.facebook.com/v13.0/112726428204479/messages"
                    req.body = JSON.dump({
                        "messaging_product": "whatsapp",
                        "to": phone_number,
                        "type": "template",
                        "template": {
                            "name": "admin_custom_message",
                            "components": components,
                            "language": {
                                "code": "en"
                            }
                        }
                    })
                    end
                render json: {data: message}, status: :created
            else
                render json: {errors: "chat not found "}, status: :unprocessable_entity
            end
        end



        private

            def encode(id)
                BuilderJsonWebToken.encode id, 'admin'
            end

            def current_user
                token = request.headers[:token] || params[:token]
                @token = BuilderJsonWebToken::JsonWebToken.decode(token)
                AdminUser.find(@token.admin_id)
            end
      
    end
end