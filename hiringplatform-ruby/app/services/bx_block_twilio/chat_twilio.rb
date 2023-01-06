# Create by Punit 
module BxBlockTwilio
  require 'twilio-ruby'

    class ChatTwilio

    def initialize
      account_sid =  ENV['TWILIO_ACCOUNT_SID']
      auth_token = ENV['TWILIO_AUTH_TOKEN']
      # Createing a Client 
      # we need Twilio Client for Access the Twilo's api
      @twilio_client = Twilio::REST::Client.new(account_sid, auth_token)
    end
    
    # Create Conversation
    def create_conversations(client, candidate)
      begin
        unique_name = "#{client.email}_#{candidate.email}_hiring" # Create a unique name for Conversation Useing Client Email and Candidate Email
        friendly_name = "#{client.first_name}#{client.last_name}__#{candidate.first_name}#{candidate.last_name}"
        conversation = @twilio_client.conversations.conversations.create(unique_name: unique_name, friendly_name: friendly_name)
        client_participant = create_participants(conversation.sid, client.email) 
        candidate_participant = create_participants(conversation.sid, candidate.email)
        return OpenStruct.new(success?: true, conversation: conversation, client_participant: client_participant, candidate_participant: candidate_participant)
      rescue => exception
        return OpenStruct.new(success?: false, errors: exception)
      end
    end

    def delete_conversation(conversation_sid, current_user)
      begin
        return OpenStruct.new(success?: false, errors: "User not a participants in conversation") unless check_participant(conversation_sid, current_user).success?
        @twilio_client.conversations.conversations(conversation_sid).delete
        return OpenStruct.new(success?: true, message: "conversation delete successfull")
      rescue => exception
        return OpenStruct.new(success?: false, errors: exception)        
      end
    end

    # Checking Paticipant Twilio 
    def check_participant(conversation_sid, current_user)
      participants = @twilio_client.conversations
      .conversations(conversation_sid)
      .participants
      .list(limit: 20)

      emails = participants.map{ |a| a.identity }

      return emails.include?(current_user.email) ? OpenStruct.new(success?: true) : OpenStruct.new(success?: false)
    end

    # Createing a Twilio message  
    def create_message
      message = @twilio_client.conversations
                 .conversations(params[:conversation_sid])
                 .messages
                 .create(author: current_user.email, body: params[:message])
      render json: {data: {
          message_sid: message.sid,
          conversation_sid: message.conversation_sid,
          body: message.body,
          participant_sid: message.participant_sid,
          delivery: message.delivery
      }}, status: :ok
    end

    # Createing a Participant or adding a user in conversation
    def create_participants(conversation_sid, email)
    participant = @twilio_client.conversations
                    .conversations(conversation_sid)
                    .participants
                    .create(identity: email)

    end

    # Creating a token for Front end Use
    def self.get_token(current_user)
      grant = Twilio::JWT::AccessToken::ChatGrant.new
      grant.service_sid = ENV['TWILIO_CHAT_SERVICE_SID']
      token = Twilio::JWT::AccessToken.new(
          ENV['TWILIO_ACCOUNT_SID'],
          ENV['TWILIO_API_KEY'],
          ENV['TWILIO_API_SECRET'] ,
          [grant],
          identity: current_user.email
      )
    end
    
    # Sending the Message on Whatsapp Usering the Tamplate and components, 
    # in Whatsapp components are like params of value passed in template 
    def self.send_whatspp_message(account, template, components)
      response = Faraday.send('post') do |req|
        req.headers[:Content_Type] = 'application/json'
        req.headers[:Authorization] = ENV["WHATSAPP_TOKEN"]
        req.url ENV["WHATSAPP_MESSAGE_URL"]
        req.body = JSON.dump({
          "messaging_product": "whatsapp",
          "to": account.phone_number,
          "type": "template",
          "template": {
              "name": template,
              "components": components,
              "language": {
                  "code": "en"
              }
          }
        })
      end
      response = JSON.parse(response.body)
    end


  end
end