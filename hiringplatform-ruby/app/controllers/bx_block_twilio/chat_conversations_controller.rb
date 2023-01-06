module BxBlockTwilio
    class ChatConversationsController < ApplicationController
    before_action :current_user, only: [:create_conversations]
    before_action :initialize_users, only: [:create_conversations]

    # Create by Punit
    # Create a conversation Token for user for use by Front End 
    def create  
      begin
        token = ChatTwilio.get_token(current_user)
        render json: {username: current_user.email, token: token.to_jwt}
      rescue => exception
        render json: {errors: exception}, status: :unprocessable_entity
      end
    end

    # Create by Punit
    # Create a conversation usering a email address
    def create_conversations
      data = ChatTwilio.new().create_conversations(@client, @candidate)
      if data.success?
        conversation = Conversation.new(
          conversation_sid: data.conversation.sid,
          unique_name: data.conversation.unique_name, 
          friendly_name: data.conversation.friendly_name,
          url: data.conversation.url,
          client_id: @client.id,
          candidate_id: @candidate.id,
          client_sid: data.client_participant.sid,
          candidate_sid: data.candidate_participant.sid
        )
        if conversation.save
          render json: ConversationsSerializer.new(conversation).serializable_hash, status: :ok
        else
          render json: {errors: conversation.errors}, status: :unprocessable_entity
        end
      else
        render json: {errors: data.errors}, status: :unprocessable_entity
      end
    end

    # Create by Punit   
    # Get the Details for users usign the Email Address
    def user_detail
      accounts = AccountBlock::Account.where(email: params[:emails])
      host = Rails.application.routes.default_url_options[:host]
      details = accounts.map do |account|
        {
          email: account.email,
          full_name: account.user_full_name,
          photo: account.avatar.attached? ? host + Rails.application.routes.url_helpers.rails_blob_url(account.avatar, only_path: true) : "",
        }
      end
      render json: details, status: :ok
    end

    # Create by Punit   
    # Delete a Conversation from the Twilio account
    def delete_conversation
      conversation = ChatTwilio.new().delete_conversation(params[:conversation_sid], current_user)
      if conversation.success?
        Conversation.find_by(conversation_sid: params[:conversation_sid]).destroy
        render json: {message: conversation.message}, status: :ok
      else
        render json: {errors: conversation.errors}, status: :ok
      end
    end

    # Create by Punit   
    # This Method Create a Message for WhatsappMessage and send it to User usring the Template
    def custom_message
      user = AccountBlock::Account.find_by(phone_number: params[:phone_number])
      components = [
        {"type": "header", "parameters": [{ "type": "text", "text": "#{user.user_full_name}" }],
        },
        {"type": "body", "parameters": [{"type": "text", "text": "#{current_user.user_full_name}"},{ "type": "text", "text": "#{params[:message]}"}, { "type": "text", "text": "#{current_user.email}" } ]
        }]

      response = BxBlockTwilio::ChatTwilio.send_whatspp_message(user, "new_custom_message_template", components)
      render json: response, status: 200
    end

    private

    def initialize_users
      if @current_user.user_role == 'client'
        @candidate = AccountBlock::Account.find_by(email: params[:email])
        @client =  @current_user
      else
        @candidate = @current_user
        @client = AccountBlock::Account.find_by(email: params[:email])
      end
      unless @candidate.present?
        return render json: {error: "Candidate not exist"}, status: :unprocessable_entity 
      end
      unless @client.present?
        return render json: {error: "Client not exist"}, status: :unprocessable_entity 
      end
    end

  end
end